import secrets
from typing import List
from datetime import datetime
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.models.staff_member import StaffMember, StaffStatus
from app.models.staff_card import StaffCard, CardStatus
from app.schemas.staff import StaffMemberCreate, StaffMemberUpdate
from app.schemas.staff_card import StaffCardCreate, StaffCardUpdate
from app.models.admin_user import AdminUser
from app.core.permissions import AdminRole, has_role_or_above

def generate_staff_id(db: Session) -> str:
    # Prefix: GAHTO
    # Example format: GAHTO-00126
    count = db.query(func.count(StaffMember.id)).scalar() or 0
    while True:
        count += 1
        proposed_id = f"GAHTO-{count:05d}"
        exists = db.query(StaffMember).filter(StaffMember.staff_id == proposed_id).first()
        if not exists:
            return proposed_id

def create_staff_member(db: Session, payload: StaffMemberCreate, current_admin: AdminUser) -> StaffMember:
    # If the user is a super admin, they can directly create active staff
    # If not, the staff is automatically pending approval

    status_to_set = StaffStatus.PENDING_APPROVAL.value
    if has_role_or_above(current_admin.role, AdminRole.SUPER_ADMIN):
        # Only super admin can create active users directly. Otherwise, it overrides.
        status_to_set = payload.status if payload.status else StaffStatus.ACTIVE.value

    new_staff_id = generate_staff_id(db)

    db_staff = StaffMember(
        staff_id=new_staff_id,
        first_name=payload.first_name,
        middle_name=payload.middle_name,
        last_name=payload.last_name,
        email=payload.email,
        phone=payload.phone,
        position=payload.position,
        department=payload.department,
        photo_url=payload.photo_url,
        status=status_to_set,
        date_joined=payload.date_joined
    )

    db.add(db_staff)
    db.commit()
    db.refresh(db_staff)
    return db_staff

def update_staff_member(db: Session, staff: StaffMember, payload: StaffMemberUpdate, current_admin: AdminUser) -> StaffMember:
    # Only super admin can change status to active
    update_data = payload.model_dump(exclude_unset=True)

    if "status" in update_data:
        if update_data["status"] == StaffStatus.ACTIVE.value and not has_role_or_above(current_admin.role, AdminRole.SUPER_ADMIN):
            raise ValueError("Only Super Admin can approve/activate staff members.")

    for key, value in update_data.items():
        setattr(staff, key, value)

    db.commit()
    db.refresh(staff)
    return staff

def issue_staff_card(db: Session, staff_id: int, current_admin: AdminUser) -> StaffCard:
    if not has_role_or_above(current_admin.role, AdminRole.SUPER_ADMIN):
        raise ValueError("Only Super Admin can issue staff cards.")

    staff = db.query(StaffMember).filter(StaffMember.id == staff_id).first()
    if not staff:
        raise ValueError("Staff member not found")

    if staff.status != StaffStatus.ACTIVE.value:
        raise ValueError("Cannot issue a card to an inactive or pending staff member")

    # Mark existing active cards as replaced
    existing_active = db.query(StaffCard).filter(
        StaffCard.staff_id == staff_id,
        StaffCard.status == CardStatus.ACTIVE.value
    ).all()

    new_version = 1
    for card in existing_active:
        new_version = max(new_version, card.version + 1)
        card.status = CardStatus.REPLACED.value
        card.revocation_reason = "Replaced by a newer version"
        card.revoked_at = datetime.utcnow()

    # Generate unique secure token and ID
    verification_token = secrets.token_urlsafe(32)
    card_id = f"CRD-{secrets.token_hex(6).upper()}"

    new_card = StaffCard(
        card_id=card_id,
        staff_id=staff_id,
        verification_token=verification_token,
        status=CardStatus.ACTIVE.value,
        version=new_version
    )

    db.add(new_card)
    db.commit()
    db.refresh(new_card)

    return new_card

def revoke_staff_card(db: Session, card: StaffCard, reason: str, current_admin: AdminUser) -> StaffCard:
    if not has_role_or_above(current_admin.role, AdminRole.SUPER_ADMIN):
        raise ValueError("Only Super Admin can revoke staff cards.")

    card.status = CardStatus.REVOKED.value
    card.revocation_reason = reason
    card.revoked_at = datetime.utcnow()

    db.commit()
    db.refresh(card)
    return card
