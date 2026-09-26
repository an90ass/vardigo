from typing import Optional
from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from app.services.offer_service import OfferService
from app.schemas.offer import Offer, OfferListResponse, CreateOfferRequest
from app.schemas.common import ApiResponse, ErrorDetail
from app.models.enums import OfferStatus, OfferStatusFilter, UserRole
from app.dependencies import get_offer_service, require_employer, require_worker

router = APIRouter(
    prefix="/api/offers",
    tags=["Offers"]
)

@router.get("", response_model=ApiResponse[OfferListResponse], response_model_exclude_none=True)
def get_offers(
    status_filter: Optional[OfferStatusFilter] = OfferStatusFilter.PENDING,
    _role: UserRole = Depends(require_worker),
    offer_service: OfferService = Depends(get_offer_service)
):

    status_val = status_filter.value if status_filter else "pending"
    data = offer_service.get_offers_list(status=status_val)
    return ApiResponse(data=data)


@router.post("", response_model=ApiResponse[dict], response_model_exclude_none=True)
def create_offers(
    request: CreateOfferRequest,
    _role: UserRole = Depends(require_employer),
    offer_service: OfferService = Depends(get_offer_service)
):
 
    try:
        created = offer_service.create_offers(request.workerIds)
        return ApiResponse(data={"created": [c.model_dump() for c in created]})
    except ValueError as ve:
        return JSONResponse(
            status_code=status.HTTP_400_BAD_REQUEST,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="EMPTY_SELECTION", message=str(ve))
            ).model_dump()
        )


@router.post("/{offer_id}/accept", response_model=ApiResponse[Offer], response_model_exclude_none=True)
def accept_offer(
    offer_id: str,
    _role: UserRole = Depends(require_worker),
    offer_service: OfferService = Depends(get_offer_service)
):

    try:
        updated_offer = offer_service.respond_to_offer(offer_id, OfferStatus.ACCEPTED)
        return ApiResponse(data=updated_offer)
    except KeyError as ke:
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="OFFER_NOT_FOUND", message=str(ke))
            ).model_dump()
        )
    except ValueError as ve:
        return JSONResponse(
            status_code=status.HTTP_409_CONFLICT,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="OFFER_STATE_ERROR", message=str(ve))
            ).model_dump()
        )


@router.post("/{offer_id}/reject", response_model=ApiResponse[Offer], response_model_exclude_none=True)
def reject_offer(
    offer_id: str,
    _role: UserRole = Depends(require_worker),
    offer_service: OfferService = Depends(get_offer_service)
):

    try:
        updated_offer = offer_service.respond_to_offer(offer_id, OfferStatus.REJECTED)
        return ApiResponse(data=updated_offer)
    except KeyError as ke:
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="OFFER_NOT_FOUND", message=str(ke))
            ).model_dump()
        )
    except ValueError as ve:
        return JSONResponse(
            status_code=status.HTTP_409_CONFLICT,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="OFFER_STATE_ERROR", message=str(ve))
            ).model_dump()
        )


@router.get("/{offer_id}", response_model=ApiResponse[dict], response_model_exclude_none=True)
def get_offer_detail(
    offer_id: str,
    _role: UserRole = Depends(require_worker),
    offer_service: OfferService = Depends(get_offer_service)
):
    try:
        data = offer_service.get_offer_detail(offer_id)
        return ApiResponse(data=data)
    except KeyError as ke:
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content=ApiResponse(
                ok=False,
                error=ErrorDetail(code="OFFER_NOT_FOUND", message=str(ke))
            ).model_dump()
        )
