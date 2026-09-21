import pyotp
import secrets
from datetime import datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.security import (
    create_access_token,
    decode_token,
    hash_password,
    verify_password,
)
from app.db.session import get_db
from app.models.admin_user import AdminUser
from app.schemas.auth import (
    AdminLoginRequest,
    TokenResponse,
    AdminUserResponse,
    ForgotPasswordRequest,
    ForgotPasswordResponse,
    ResetPasswordRequest,
    MessageResponse,
)
from app.core.permissions import AdminRole, has_role_or_above

router = APIRouter(prefix="/auth", tags=["Authentication"])

security = HTTPBearer()


@router.post("/login", response_model=TokenResponse)
def login_admin(payload: AdminLoginRequest, db: Session = Depends(get_db)):
    admin = db.query(AdminUser).filter(AdminUser.email == payload.email).first()

    if not admin or not verify_password(payload.password, admin.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    if not admin.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin account is inactive",
        )

    # 2FA Logic
    if not admin.totp_secret:
        # Require them to pass a flag that they are ready to setup
        if not payload.totp_code:
            # We haven't generated a secret yet, and they haven't submitted a code.
            # Generate temporary secret, send URI, wait for them to scan and submit code to confirm
            temp_secret = pyotp.random_base32()
            totp_uri = pyotp.totp.TOTP(temp_secret).provisioning_uri(
                name=admin.email, issuer_name="GAHTO Admin"
            )
            return TokenResponse(requires_2fa_setup=True, totp_uri=totp_uri, temp_secret=temp_secret)
        else:
            # They submitted a setup code. We MUST verify it against the temp secret they were given
            if not payload.temp_secret:
                raise HTTPException(status_code=400, detail="Missing temporary secret for setup.")

            totp = pyotp.TOTP(payload.temp_secret)
            if not totp.verify(payload.totp_code):
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid initial setup code. Try scanning again.")

            # Setup successful! Now we save it permanently.
            admin.totp_secret = payload.temp_secret
            db.commit()
    else:
        # Standard login for already setup accounts
        if not payload.totp_code:
            return TokenResponse(requires_2fa=True)

        totp = pyotp.TOTP(admin.totp_secret)
        if not totp.verify(payload.totp_code):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication code",
            )

    token = create_access_token(subject=admin.id)
    return TokenResponse(access_token=token)


def get_current_admin(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> AdminUser:
    token = credentials.credentials
    payload = decode_token(token)

    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )

    admin_id = payload.get("sub")
    if not admin_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload",
        )

    admin = db.query(AdminUser).filter(AdminUser.id == int(admin_id)).first()
    if not admin:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Admin not found",
        )

    if not admin.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin account is inactive",
        )

    return admin


def require_content_admin(
    current_admin: AdminUser = Depends(get_current_admin),
) -> AdminUser:
    if not has_role_or_above(current_admin.role, AdminRole.CONTENT_ADMIN):
        raise HTTPException(status_code=403, detail="Insufficient permissions")
    return current_admin


def require_operations_admin(
    current_admin: AdminUser = Depends(get_current_admin),
) -> AdminUser:
    if not has_role_or_above(current_admin.role, AdminRole.OPERATIONS_ADMIN):
        raise HTTPException(status_code=403, detail="Operations Admin access required")
    return current_admin


def require_super_admin(
    current_admin: AdminUser = Depends(get_current_admin),
) -> AdminUser:
    if current_admin.role != AdminRole.SUPER_ADMIN.value or not current_admin.is_superuser:
        raise HTTPException(status_code=403, detail="Super Admin access required")
    return current_admin


@router.get("/me", response_model=AdminUserResponse)
def get_logged_in_admin(current_admin: AdminUser = Depends(get_current_admin)):
    return current_admin


@router.post("/forgot-password", response_model=ForgotPasswordResponse)
def forgot_password(payload: ForgotPasswordRequest, db: Session = Depends(get_db)):
    admin = db.query(AdminUser).filter(AdminUser.email == payload.email).first()

    generic_message = "If the account exists, a password reset link has been generated."

    if not admin or not admin.is_active:
        return ForgotPasswordResponse(message=generic_message)

    token = secrets.token_urlsafe(32)
    expires_at = datetime.utcnow() + timedelta(minutes=30)

    admin.reset_token = token
    admin.reset_token_expires_at = expires_at
    db.commit()

    return ForgotPasswordResponse(message=generic_message)


@router.post("/reset-password", response_model=MessageResponse)
def reset_password(payload: ResetPasswordRequest, db: Session = Depends(get_db)):
    admin = db.query(AdminUser).filter(AdminUser.reset_token == payload.token).first()

    if not admin:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired reset token",
        )

    if not admin.reset_token_expires_at or admin.reset_token_expires_at < datetime.utcnow():
        admin.reset_token = None
        admin.reset_token_expires_at = None
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Reset token has expired",
        )

    admin.password_hash = hash_password(payload.new_password)
    admin.reset_token = None
    admin.reset_token_expires_at = None
    db.commit()

    return MessageResponse(message="Password has been reset successfully")
