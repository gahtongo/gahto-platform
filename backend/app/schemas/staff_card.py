from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field
from app.schemas.staff import StaffMemberResponse


class StaffPublicProfile(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    staff_id: str
    first_name: str
    last_name: str
    position: str
    photo_url: str | None = None



class StaffCardPublicResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    status: str
    version: int
    issued_at: datetime
    expires_at: datetime | None = None
    staff: StaffPublicProfile


class StaffCardBase(BaseModel):
    status: str = Field(default="active")
    expires_at: datetime | None = None

class StaffCardCreate(StaffCardBase):
    staff_id: int

class StaffCardUpdate(BaseModel):
    status: str | None = None
    revocation_reason: str | None = Field(None, max_length=500)

class StaffCardResponse(StaffCardBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    card_id: str
    staff_id: int
    verification_token: str
    version: int
    issued_at: datetime
    revoked_at: datetime | None = None
    revocation_reason: str | None = None

    staff: StaffMemberResponse | None = None

