from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.dependencies.database_deps import get_db
from app.models import UserORM, UserRole
from app.repositories.user_repository import UserRepository
from app.services.auth_service import AuthService

security = HTTPBearer()

def get_user_repository(db: Session = Depends(get_db)) -> UserRepository:
    return UserRepository(db)

def get_auth_service(user_repo: UserRepository = Depends(get_user_repository)) -> AuthService:
    return AuthService(user_repo)

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    auth_service: AuthService = Depends(get_auth_service)
) -> UserORM:
    token = credentials.credentials.strip() if credentials else ""
    return auth_service.verify_token(token)

def get_current_user_role(
    current_user: UserORM = Depends(get_current_user)
) -> UserRole:
    return current_user.role

def require_role(allowed_role: UserRole):
    def role_checker(current_user: UserORM = Depends(get_current_user)) -> UserORM:
        if current_user.role != allowed_role:
            role_label = "işveren" if allowed_role == UserRole.EMPLOYER else "iş arayan"
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Bu işlemi sadece {role_label} hesabı gerçekleştirebilir."
            )
        return current_user
    return role_checker

require_employer = require_role(UserRole.EMPLOYER)
require_worker = require_role(UserRole.WORKER)
