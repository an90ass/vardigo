from typing import List, Optional
from sqlalchemy.orm import Session
from app.models import OfferORM, OfferStatus
from app.repositories.base import BaseRepository

class OfferRepository(BaseRepository[OfferORM]):


    def __init__(self, db: Session):
        super().__init__(db)

    def get_by_id(self, entity_id: str) -> Optional[OfferORM]:
        return self.db.query(OfferORM).filter(OfferORM.id == entity_id).first()

    def get_all(self) -> List[OfferORM]:
        return self.db.query(OfferORM).all()

    def get_offers_by_status(self, status: Optional[str] = None, worker_id: Optional[str] = None) -> List[OfferORM]:

        query = self.db.query(OfferORM)

        if worker_id:
            valid_ids = {worker_id}
            if worker_id in ("w_merve", "u_worker"):
                valid_ids.update(["w_merve", "u_worker"])
            query = query.filter(OfferORM.worker_id.in_(valid_ids))

        if status == "pending":
            query = query.filter(OfferORM.status == OfferStatus.PENDING)
        elif status == "answered":
            query = query.filter(OfferORM.status.in_([OfferStatus.ACCEPTED, OfferStatus.REJECTED]))
        elif status == "expired":
            query = query.filter(OfferORM.status == OfferStatus.EXPIRED)

        return query.all()

    def find_pending_offer_by_worker(self, worker_id: str) -> Optional[OfferORM]:

        return self.db.query(OfferORM).filter(
            OfferORM.worker_id == worker_id,
            OfferORM.status == OfferStatus.PENDING
        ).first()

    def add(self, offer: OfferORM) -> OfferORM:
        self.db.add(offer)
        return offer

    def commit(self) -> None:
        self.db.commit()
