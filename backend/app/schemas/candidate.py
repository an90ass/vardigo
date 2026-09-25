import uuid
from pydantic import BaseModel, Field
from typing import List

class Candidate(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    rating: str
    attend: str
    km: str
    kmValue: float
    photo: str
    online: bool
    perfect: bool
    score: int

class CandidateListResponse(BaseModel):
    totalPerfect: int
    totalSimilar: int
    selectedHint: int = 1
    candidates: List[Candidate]
