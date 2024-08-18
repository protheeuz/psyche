from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr
    username: str

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True

class ScreeningBase(BaseModel):
    score: int
    result: str

class ScreeningCreate(ScreeningBase):
    pass

class ScreeningResponse(ScreeningBase):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        orm_mode = True

class NoteBase(BaseModel):
    note_text: str
    note_color: Optional[str] = None

class NoteCreate(NoteBase):
    pass

class NoteResponse(NoteBase):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        orm_mode = True