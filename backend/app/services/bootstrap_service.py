from sqlalchemy.orm import Session

from app.core.config import get_settings
from app.core.security import hash_password
from app.models.admin_user import AdminUser
from app.models.staff_member import StaffMember
from app.services.staff_service import generate_staff_id

settings = get_settings()


def create_first_superadmin(db: Session) -> None:
    if not settings.FIRST_SUPERADMIN_EMAIL.strip() or not settings.FIRST_SUPERADMIN_PASSWORD:
        return

    existing_admin = (
        db.query(AdminUser)
        .filter(AdminUser.email == settings.FIRST_SUPERADMIN_EMAIL)
        .first()
    )

    if existing_admin:
        return

    admin = AdminUser(
        full_name="GAHTO Super Admin",
        email=settings.FIRST_SUPERADMIN_EMAIL,
        password_hash=hash_password(settings.FIRST_SUPERADMIN_PASSWORD),
        role="super_admin",
        is_active=True,
        is_superuser=True,
    )
    db.add(admin)
    db.commit()


def seed_initial_staff(db: Session):
    hardcoded_staff = [
        {'name': 'J. Maidaki', 'role': 'Advocate'},
        {'name': 'B. Alabi', 'role': 'Counselor'},
        {'name': 'P. Adeniran', 'role': 'Coordinator'},
        {'name': 'E. Robert', 'role': 'Case Manager'},
        {'name': 'J. Olatimehin', 'role': 'Lead Investigator'}
    ]

    for s in hardcoded_staff:
        # Avoid duplicates
        last_name_part = s['name'].split()[1] if len(s['name'].split()) > 1 else ''
        exists = db.query(StaffMember).filter(
            StaffMember.last_name == last_name_part
        ).first()

        if not exists:
            parts = s['name'].split()
            first_name = parts[0]
            last_name = parts[1] if len(parts) > 1 else ''
            new_id = generate_staff_id(db)
            db_staff = StaffMember(
                staff_id=new_id,
                first_name=first_name,
                last_name=last_name,
                position=s['role'],
                status='active'
            )
            db.add(db_staff)
            db.commit()
