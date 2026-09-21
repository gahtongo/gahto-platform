import secrets
from pathlib import Path

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy.orm import Session

from app.api.routes.auth import require_super_admin
from app.core.config import settings as app_settings
from app.db.session import get_db
from app.models.admin_user import AdminUser
from app.models.site_setting import SiteSetting
from app.schemas.settings import SiteSettingCreate, SiteSettingResponse, SiteSettingUpdate

router = APIRouter(prefix="/settings", tags=["Settings"])


@router.get("/public", response_model=list[SiteSettingResponse])
def get_public_settings(db: Session = Depends(get_db)):
    return db.query(SiteSetting).filter(SiteSetting.is_public == True).order_by(SiteSetting.key.asc()).all()  # noqa: E712


@router.get("/admin", response_model=list[SiteSettingResponse])
def get_all_settings(db: Session = Depends(get_db), current_admin: AdminUser = Depends(require_super_admin)):
    _ = current_admin
    return db.query(SiteSetting).order_by(SiteSetting.key.asc()).all()


@router.post("/admin", response_model=SiteSettingResponse)
def create_setting(payload: SiteSettingCreate, db: Session = Depends(get_db), current_admin: AdminUser = Depends(require_super_admin)):
    _ = current_admin
    if db.query(SiteSetting).filter_by(key=payload.key).first():
        raise HTTPException(status_code=400, detail="Key already exists")
    setting = SiteSetting(**payload.model_dump())
    db.add(setting)
    db.commit()
    db.refresh(setting)
    return setting


@router.post("/admin/upload", response_model=SiteSettingResponse)
async def upload_setting_file(key: str, file: UploadFile = File(...), db: Session = Depends(get_db), current_admin: AdminUser = Depends(require_super_admin)):
    _ = current_admin
    extensions = {"image/jpeg": "jpg", "image/png": "png", "image/webp": "webp"}
    if file.content_type not in extensions:
        raise HTTPException(status_code=415, detail="Unsupported image format")
    safe_key = "".join(c for c in key if c.isalnum() or c in {"-", "_"})
    if not safe_key:
        raise HTTPException(status_code=400, detail="Invalid setting key")
    filename = f"setting_{safe_key}_{secrets.token_hex(4)}.{extensions[file.content_type]}"
    upload_path = Path(app_settings.MEDIA_UPLOAD_DIR) / filename
    max_bytes = min(app_settings.MAX_UPLOAD_SIZE_MB, 5) * 1024 * 1024
    bytes_written = 0
    with upload_path.open("wb") as buffer:
        while chunk := await file.read(1024 * 1024):
            bytes_written += len(chunk)
            if bytes_written > max_bytes:
                buffer.close()
                upload_path.unlink(missing_ok=True)
                raise HTTPException(status_code=413, detail="Setting image is too large")
            buffer.write(chunk)
    setting = db.query(SiteSetting).filter_by(key=key).first()
    if not setting:
        setting = SiteSetting(key=key, value=f"/uploads/{filename}", description="Uploaded file", is_public=False)
        db.add(setting)
    else:
        setting.value = f"/uploads/{filename}"
    db.commit()
    db.refresh(setting)
    return setting


@router.put("/admin/{key}", response_model=SiteSettingResponse)
def update_setting(key: str, payload: SiteSettingUpdate, db: Session = Depends(get_db), current_admin: AdminUser = Depends(require_super_admin)):
    _ = current_admin
    setting = db.query(SiteSetting).filter_by(key=key).first()
    if not setting:
        raise HTTPException(status_code=404, detail="Setting not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(setting, field, value)
    db.commit()
    db.refresh(setting)
    return setting
