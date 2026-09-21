from typing import List
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
import os
import secrets
from pathlib import Path

from app.api.routes.auth import require_content_admin, require_super_admin
from app.db.session import get_db
from app.core.config import settings
from app.models.admin_user import AdminUser
from app.models.staff_member import StaffMember
from app.models.staff_card import StaffCard
from app.schemas.staff import StaffMemberCreate, StaffMemberUpdate, StaffMemberResponse
from app.schemas.staff_card import StaffCardPublicResponse, StaffCardResponse, StaffCardUpdate
from app.services.staff_service import (
    create_staff_member,
    update_staff_member,
    issue_staff_card,
    revoke_staff_card
)
from app.core.permissions import AdminRole, has_role_or_above

router = APIRouter(prefix="/staff", tags=["Staff Management"])

# -----------------
# STAFF ENDPOINTS
# -----------------

@router.get("", response_model=List[StaffMemberResponse])
def get_staff_members(
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    # Both content_admin and super_admin can view staff list
    return db.query(StaffMember).all()

@router.post("", response_model=StaffMemberResponse, status_code=status.HTTP_201_CREATED)
def create_staff(
    payload: StaffMemberCreate,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    # The service automatically assigns 'pending_approval' if it's not a super_admin
    return create_staff_member(db, payload, current_admin)

@router.get("/{staff_id}", response_model=StaffMemberResponse)
def get_single_staff(
    staff_id: int,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise HTTPException(status_code=404, detail="Staff member not found")
    return staff

@router.put("/{staff_id}", response_model=StaffMemberResponse)
def update_staff(
    staff_id: int,
    payload: StaffMemberUpdate,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise HTTPException(status_code=404, detail="Staff member not found")

    try:
        return update_staff_member(db, staff, payload, current_admin)
    except ValueError as exc:
        raise HTTPException(status_code=403, detail=str(exc))

@router.post("/{staff_id}/photo", response_model=StaffMemberResponse)
async def upload_staff_photo(
    staff_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise HTTPException(status_code=404, detail="Staff member not found")

    allowed_types = ["image/jpeg", "image/png", "image/webp"]
    if file.content_type not in allowed_types:
        raise HTTPException(status_code=415, detail="Unsupported image format. Use JPEG, PNG, or WEBP.")

    extension_by_type = {"image/jpeg": "jpg", "image/png": "png", "image/webp": "webp"}
    ext = extension_by_type[file.content_type]
    safe_filename = f"staff_{staff.staff_id}_{secrets.token_hex(4)}.{ext}"
    upload_path = Path(settings.MEDIA_UPLOAD_DIR) / safe_filename

    max_bytes = min(settings.MAX_UPLOAD_SIZE_MB, 8) * 1024 * 1024
    bytes_written = 0
    with upload_path.open("wb") as buffer:
        while chunk := await file.read(1024 * 1024):
            bytes_written += len(chunk)
            if bytes_written > max_bytes:
                buffer.close()
                upload_path.unlink(missing_ok=True)
                raise HTTPException(status_code=413, detail="Staff photo is too large")
            buffer.write(chunk)

    # Use full absolute URL for easier local/prod compatibility, or just relative
    staff.photo_url = f"/uploads/{safe_filename}"
    db.commit()
    db.refresh(staff)
    return staff

@router.delete("/{staff_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_staff(
    staff_id: int,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_super_admin)
):
    if not has_role_or_above(current_admin.role, AdminRole.SUPER_ADMIN):
        raise HTTPException(status_code=403, detail="Only Super Admin can delete staff records")

    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise HTTPException(status_code=404, detail="Staff member not found")

    db.delete(staff)
    db.commit()
    return None

# -----------------
# CARD ENDPOINTS
# -----------------

@router.get("/{staff_id}/cards", response_model=List[StaffCardResponse])
def get_staff_cards(
    staff_id: int,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_content_admin)
):
    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise HTTPException(status_code=404, detail="Staff member not found")
    return staff.cards

@router.post("/{staff_id}/cards/issue", response_model=StaffCardResponse, status_code=status.HTTP_201_CREATED)
def issue_card(
    staff_id: int,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_super_admin)
):
    try:
        return issue_staff_card(db, staff_id, current_admin)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))

@router.post("/cards/{card_id}/revoke", response_model=StaffCardResponse)
def revoke_card(
    card_id: int,
    payload: StaffCardUpdate,
    db: Session = Depends(get_db),
    current_admin: AdminUser = Depends(require_super_admin)
):
    card = db.query(StaffCard).filter(StaffCard.id == card_id).first()
    if not card:
        raise HTTPException(status_code=404, detail="Staff card not found")

    reason = payload.revocation_reason or "Revoked by admin"
    try:
        return revoke_staff_card(db, card, reason, current_admin)
    except ValueError as exc:
        raise HTTPException(status_code=403, detail=str(exc))

@router.get("/cards/verify/{token}", response_model=StaffCardPublicResponse)
def verify_card(
    token: str,
    db: Session = Depends(get_db)
):
    # This is a PUBLIC endpoint! It does NOT require admin authentication.
    # It allows anyone scanning the QR code to verify the token.
    card = db.query(StaffCard).filter(StaffCard.verification_token == token).first()
    if not card:
        raise HTTPException(status_code=404, detail="Invalid verification token")
    return card
