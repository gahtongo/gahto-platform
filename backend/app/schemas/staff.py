from datetime import datetime
from pydantic import BaseModel, ConfigDict, EmailStr, Field

class StaffMemberBase(BaseModel):
    first_name: str = Field(..., max_length=100)
    middle_name: str | None = Field(None, max_length=100)
    last_name: str = Field(..., max_length=100)
    email: EmailStr | None = None
    phone: str | None = Field(None, max_length=50)
    position: str = Field(..., max_length=150)
    department: str | None = Field(None, max_length=150)
    photo_url: str | None = Field(None, max_length=500)
    status: str = Field(default="pending_approval")
    date_joined: datetime | None = None

class StaffMemberCreate(StaffMemberBase):
    pass

class StaffMemberUpdate(BaseModel):
    first_name: str | None = Field(None, max_length=100)
    middle_name: str | None = Field(None, max_length=100)
    last_name: str | None = Field(None, max_length=100)
    email: EmailStr | None = None
    phone: str | None = Field(None, max_length=50)
    position: str | None = Field(None, max_length=150)
    department: str | None = Field(None, max_length=150)
    photo_url: str | None = Field(None, max_length=500)
    status: str | None = None
    date_joined: datetime | None = None

class StaffMemberResponse(StaffMemberBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    staff_id: str
    created_at: datetime
    updated_at: datetime

