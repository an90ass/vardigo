from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.models.enums import UserRole

security = HTTPBearer()

def get_auth_service():
    from app.services.auth_service import AuthService
    return AuthService()

def get_current_user_role(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> UserRole:

    token = credentials.credentials.strip() if credentials else ""

    if token == "dev-employer":
        return UserRole.EMPLOYER
    elif token == "dev-worker":
        return UserRole.WORKER

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Geçersiz token (Bearer dev-employer veya dev-worker gereklidir)."
    )

def require_role(allowed_role: UserRole):

    def role_checker(current_role: UserRole = Depends(get_current_user_role)) -> UserRole:
        if current_role != allowed_role:
            role_label = "işveren" if allowed_role == UserRole.EMPLOYER else "iş arayan"
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Bu işlemi sadece {role_label} hesabı gerçekleştirebilir."
            )
        return current_role
    return role_checker

require_employer = require_role(UserRole.EMPLOYER)
require_worker = require_role(UserRole.WORKER)
