from typing import List, Optional
from sqlalchemy.orm import Session
from app.models import OfferORM
from app.repositories.base import BaseRepository

class OfferRepository(BaseRepository[OfferORM]):
    def __init__(self, db: Session):
        super().__init__(db)

    def get_by_id(self, entity_id: str) -> Optional[OfferORM]:
        return self.db.query(OfferORM).filter(OfferORM.id == entity_id).first()

    def get_all(self) -> List[OfferORM]:
        return self.db.query(OfferORM).all()

    def add(self, offer: OfferORM) -> OfferORM:
        self.db.add(offer)
        return offer

    def commit(self) -> None:
        self.db.commit()
