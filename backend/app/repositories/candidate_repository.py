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

    def add(self, candidate: CandidateORM) -> CandidateORM:
        self.db.add(candidate)
        return candidate

    def commit(self) -> None:
        self.db.commit()
