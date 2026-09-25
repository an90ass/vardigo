from fastapi import Header, HTTPException, status
from typing import Optional
from app.models.enums import UserRole
from app.services.auth_service import AuthService

def get_auth_service() -> AuthService:
    #Dependency injector for AuthService
    return AuthService()

def get_current_user_role(authorization: Optional[str] = Header(None)) -> UserRole:

    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authorization header eksik veya geçersiz (Bearer <token> gereklidir)."
        )

    token = authorization.replace("Bearer ", "").strip()
    if token == "dev-employer":
        return UserRole.EMPLOYER
    elif token == "dev-worker":
        return UserRole.WORKER

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Geçersiz token."
    )
