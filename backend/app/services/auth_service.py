from fastapi import HTTPException, status
from app.models import UserORM, UserRole
from app.repositories.user_repository import UserRepository
from app.schemas.auth import LoginResponse

class AuthService:

    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    def authenticate(self, role: UserRole) -> LoginResponse:
        user = self.user_repo.get_by_role(role)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"'{role.value}' rolüne sahip kullanıcı bulunamadı."
            )
        return LoginResponse(token=user.token, role=user.role)

    def verify_token(self, token: str) -> UserORM:
        user = self.user_repo.get_by_token(token)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Geçersiz veya yetkisiz token."
            )
        return user
