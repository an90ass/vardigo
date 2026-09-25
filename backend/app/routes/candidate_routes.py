from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from app.services.candidate_service import CandidateService
from app.schemas.candidate import CandidateListResponse
from app.schemas.common import ApiResponse
from app.models.enums import CandidateTab, CandidateSort, UserRole
from app.dependencies import get_candidate_service, get_current_user_role

router = APIRouter(
    prefix="/api/candidates",
    tags=["Candidates"]
)

@router.get("", response_model=ApiResponse[CandidateListResponse], response_model_exclude_none=True)
def get_candidates(
    tab: Optional[CandidateTab] = None,
    sort: Optional[CandidateSort] = None,
    current_role: UserRole = Depends(get_current_user_role),
    candidate_service: CandidateService = Depends(get_candidate_service)
):
    """
    GET /api/candidates
    Retrieves matching candidates for employers.
    Requires Employer token (Authorization: Bearer dev-employer).
    """
    if current_role != UserRole.EMPLOYER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Aday listesini sadece işveren hesabı görüntüleyebilir."
        )

    tab_val = tab.value if tab else None
    sort_val = sort.value if sort else None
    data = candidate_service.get_candidates_list(tab=tab_val, sort=sort_val)
    return ApiResponse(data=data)
