from app.schemas.common import ApiResponse, ErrorDetail
from app.schemas.auth import LoginRequest, LoginResponse
from app.schemas.candidate import Candidate, CandidateListResponse
from app.schemas.offer import Offer, OfferListResponse, CreateOfferRequest

__all__ = [
    "ApiResponse",
    "ErrorDetail",
    "LoginRequest",
    "LoginResponse",
    "Candidate",
    "CandidateListResponse",
    "Offer",
    "OfferListResponse",
    "CreateOfferRequest"
]
