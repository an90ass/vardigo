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
    """
    Standard FastAPI Bearer Token Security Dependency.
    Provides clean single-input Authorize button in Swagger UI without parameter duplication.
    """
    token = credentials.credentials.strip() if credentials else ""

    if token == "dev-employer":
        return UserRole.EMPLOYER
    elif token == "dev-worker":
        return UserRole.WORKER

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Geçersiz token (Bearer dev-employer veya dev-worker gereklidir)."
    )
