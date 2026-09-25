import uuid
from pydantic import BaseModel, Field
from typing import List, Optional
from app.models.enums import OfferStatus

class Offer(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    workerId: str
    title: str
    place: str
    pay: str
    payValue: int
    logo: str
    district: str
    when: str
    status: OfferStatus
    expiresAt: str
    remain: Optional[str] = None

class OfferListResponse(BaseModel):
    pendingCount: int
    offers: List[Offer]

class CreateOfferRequest(BaseModel):
    workerIds: List[str]
