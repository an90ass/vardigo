from typing import List, Optional
from sqlalchemy.orm import Session
from app.models import CandidateORM
from app.repositories.base import BaseRepository

class CandidateRepository(BaseRepository[CandidateORM]):


    def __init__(self, db: Session):
        super().__init__(db)

    def get_by_id(self, entity_id: str) -> Optional[CandidateORM]:
        return self.db.query(CandidateORM).filter(CandidateORM.id == entity_id).first()

    def get_all(self) -> List[CandidateORM]:
        return self.db.query(CandidateORM).all()

    def get_candidates_filtered(self, tab: Optional[str] = None, sort: Optional[str] = None) -> List[CandidateORM]:
        # Queries candidates with tab filtering (perfect/similar) and sorting (near/rating/recommended).
        query = self.db.query(CandidateORM)

        if tab == "perfect":
            query = query.filter(CandidateORM.perfect == True)
        elif tab == "similar":
            query = query.filter(CandidateORM.perfect == False)

        if sort == "near":
            query = query.order_by(CandidateORM.kmValue.asc())
        elif sort == "rating":
            query = query.order_by(CandidateORM.rating.desc())
        else:  # default / recommended
            query = query.order_by(CandidateORM.score.desc())

        return query.all()

    def add(self, candidate: CandidateORM) -> CandidateORM:
        self.db.add(candidate)
        return candidate

    def commit(self) -> None:
        self.db.commit()
