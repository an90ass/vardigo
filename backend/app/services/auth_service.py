from fastapi import HTTPException, status
from app.models.enums import UserRole
from app.schemas.auth import LoginResponse

class AuthService:

    @staticmethod
    def authenticate(role: UserRole) -> LoginResponse:
        if role == UserRole.EMPLOYER:
            return LoginResponse(token="dev-employer", role=UserRole.EMPLOYER)
        elif role == UserRole.WORKER:
            return LoginResponse(token="dev-worker", role=UserRole.WORKER)

        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Geçersiz rol. Sadece 'employer' veya 'worker' kabul edilir."
        )
