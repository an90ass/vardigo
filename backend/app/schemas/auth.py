from pydantic import BaseModel
from app.models.enums import UserRole

class LoginRequest(BaseModel):
    role: UserRole

class LoginResponse(BaseModel):
    token: str
    role: UserRole
