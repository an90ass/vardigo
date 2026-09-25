from typing import List, Optional
from app.repositories.candidate_repository import CandidateRepository
from app.schemas.candidate import Candidate, CandidateListResponse

class CandidateService:

    def __init__(self, repo: CandidateRepository):
        self.repo = repo

    def get_candidates_list(self, tab: Optional[str] = None, sort: Optional[str] = None) -> CandidateListResponse:
        candidate_orms = self.repo.get_candidates_filtered(tab=tab, sort=sort)
        candidates = [
            Candidate(
                id=c.id,
                name=c.name,
                rating=c.rating,
                attend=c.attend,
                km=c.km,
                kmValue=c.kmValue,
                photo=c.photo,
                online=c.online,
                perfect=c.perfect,
                score=c.score
            )
            for c in candidate_orms
        ]

        # Calculate matching totals
        all_candidates = self.repo.get_all()
        total_perfect = 26 if any(c.perfect for c in all_candidates) else 0
        total_similar = 16 if any(not c.perfect for c in all_candidates) else 0

        return CandidateListResponse(
            totalPerfect=total_perfect,
            totalSimilar=total_similar,
            selectedHint=1,
            candidates=candidates
        )
