import enum
from datetime import datetime
from sqlalchemy import DateTime, Integer, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

class CardStatus(str, enum.Enum):
    ACTIVE = "active"
    REVOKED = "revoked"
    EXPIRED = "expired"
    REPLACED = "replaced"

class StaffCard(Base):
    __tablename__ = "staff_cards"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    card_id: Mapped[str] = mapped_column(String(100), unique=True, index=True, nullable=False)

    staff_id: Mapped[int] = mapped_column(Integer, ForeignKey("staff_members.id"), nullable=False)
    staff = relationship("StaffMember", back_populates="cards")

    verification_token: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)

    status: Mapped[str] = mapped_column(String(50), default=CardStatus.ACTIVE.value, nullable=False)
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)

    issued_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    expires_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)

    revoked_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    revocation_reason: Mapped[str | None] = mapped_column(String(500), nullable=True)