from fastapi import APIRouter, Depends
from app.schemas.auth import LoginRequest, LoginResponse
from app.schemas.common import ApiResponse
from app.services.auth_service import AuthService
from app.dependencies import get_auth_service

router = APIRouter()

@router.post("/login", response_model=ApiResponse[LoginResponse])
def login(
    request: LoginRequest,
    auth_service: AuthService = Depends(get_auth_service)
):

    data = auth_service.authenticate(request.role)
    return ApiResponse(data=data)
