import uuid
from datetime import datetime, timedelta, timezone
from typing import List, Optional
from app.repositories.offer_repository import OfferRepository
from app.models import OfferORM, OfferStatus, CandidateORM
from app.schemas.offer import Offer, OfferListResponse

class OfferService:

    DEFAULT_JOB_TEMPLATE = {
        "title": "Garson",
        "place": "Zarif Cheff Restaurant",
        "pay": "45.000",
        "payValue": 45000,
        "logo": "/assets/logos/zarif.svg",
        "district": "Kadıköy",
        "when_time": "16 Ağu · 12:00 - 16:00"
    }

    def __init__(self, repo: OfferRepository):
        self.repo = repo

    def _update_expired_offers(self) -> None:
        all_pending = self.repo.get_offers_by_status("pending")
        now = datetime.now(timezone.utc)
        updated = False
        for offer in all_pending:
            try:
                exp_str = str(offer.expiresAt).replace("Z", "+00:00")
                exp_dt = datetime.fromisoformat(exp_str)
                if exp_dt.tzinfo is None:
                    exp_dt = exp_dt.replace(tzinfo=timezone.utc)
                if exp_dt <= now:
                    offer.status = OfferStatus.EXPIRED
                    updated = True
            except Exception:
                pass
        if updated:
            self.repo.commit()

    def _to_schema(self, offer_orm: OfferORM) -> Offer:
        status_val = offer_orm.status.value if isinstance(offer_orm.status, OfferStatus) else str(offer_orm.status)
        remain = "0 saat 0 dakika"

        try:
            exp_str = str(offer_orm.expiresAt).replace("Z", "+00:00")
            exp_dt = datetime.fromisoformat(exp_str)
            if exp_dt.tzinfo is None:
                exp_dt = exp_dt.replace(tzinfo=timezone.utc)
            now = datetime.now(timezone.utc)
            diff = exp_dt - now

            if diff.total_seconds() <= 0:
                if status_val == OfferStatus.PENDING.value:
                    status_val = OfferStatus.EXPIRED.value
                    offer_orm.status = OfferStatus.EXPIRED
                    self.repo.commit()
                remain = "0 saat 0 dakika"
            else:
                total_seconds = int(diff.total_seconds())
                hours = total_seconds // 3600
                minutes = (total_seconds % 3600) // 60
                remain = f"{hours} saat {minutes} dakika"
        except Exception:
            pass

        return Offer(
            id=offer_orm.id,
            workerId=offer_orm.worker_id,
            title=offer_orm.title,
            place=offer_orm.place,
            pay=offer_orm.pay,
            payValue=offer_orm.payValue,
            logo=offer_orm.logo,
            district=offer_orm.district,
            when=offer_orm.when_time,
            status=OfferStatus(status_val),
            expiresAt=offer_orm.expiresAt,
            remain=remain
        )

    def get_offers_list(self, status: Optional[str] = None) -> OfferListResponse:
        #  Update any expired pending offers first
        self._update_expired_offers()

        #  Query matching status
        offer_orms = self.repo.get_offers_by_status(status=status)
        offers = [self._to_schema(o) for o in offer_orms]

        #  Calculate pending count
        all_pending = self.repo.get_offers_by_status(status="pending")
        pending_count = len(all_pending)

        return OfferListResponse(pendingCount=pending_count, offers=offers)

    def create_offers(self, worker_ids: List[str]) -> List[Offer]:
        if not worker_ids:
            raise ValueError("En az bir aday seçilmelidir.")

        created: List[Offer] = []
        now = datetime.now(timezone.utc)
        exp_dt = now + timedelta(hours=21, minutes=32)

        for w_id in worker_ids:
            # Check 404 rule: candidate must exist
            cand = self.repo.db.query(CandidateORM).filter(CandidateORM.id == w_id).first()
            if not cand and w_id != "u_worker":
                raise KeyError(f"'{w_id}' id'li aday bulunamadı.")

            # Check 409 rule: conflict if candidate already has an active pending offer
            existing_pending = self.repo.find_pending_offer_by_worker(w_id)
            if existing_pending:
                # Check if it has actually expired
                try:
                    exp_str = str(existing_pending.expiresAt).replace("Z", "+00:00")
                    exp_parsed = datetime.fromisoformat(exp_str)
                    if exp_parsed.tzinfo is None:
                        exp_parsed = exp_parsed.replace(tzinfo=timezone.utc)
                    if exp_parsed <= now:
                        existing_pending.status = OfferStatus.EXPIRED
                        self.repo.commit()
                        existing_pending = None
                except Exception:
                    pass
         
            if existing_pending:
                cand_name = cand.name if cand else (existing_pending.candidate.name if existing_pending.candidate else f"'{w_id}'")
                raise ValueError(f"{cand_name} adlı adaya zaten açık bir görüşme talebi bulunmaktadır.")

            new_id = f"o_{str(uuid.uuid4())[:8]}"
            offer_orm = OfferORM(
                id=new_id,
                worker_id=w_id,
                status=OfferStatus.PENDING,
                expiresAt=exp_dt.isoformat(),
                **self.DEFAULT_JOB_TEMPLATE
            )
            self.repo.add(offer_orm)
            created.append(self._to_schema(offer_orm))

        self.repo.commit()
        return created

    def respond_to_offer(self, offer_id: str, new_status: OfferStatus) -> Offer:
        offer_orm = self.repo.get_by_id(offer_id)
        if not offer_orm:
            raise KeyError("Teklif bulunamadı.")

        current_status = offer_orm.status.value if isinstance(offer_orm.status, OfferStatus) else str(offer_orm.status)

        # Expiration check
        try:
            exp_str = str(offer_orm.expiresAt).replace("Z", "+00:00")
            exp_dt = datetime.fromisoformat(exp_str)
            if exp_dt.tzinfo is None:
                exp_dt = exp_dt.replace(tzinfo=timezone.utc)
            if datetime.now(timezone.utc) >= exp_dt:
                if current_status == OfferStatus.PENDING.value:
                    offer_orm.status = OfferStatus.EXPIRED
                    self.repo.commit()
                raise ValueError("Teklifin süresi doldu.")
        except ValueError as ve:
            if "süresi doldu" in str(ve):
                raise ve
        except Exception:
            pass

        if current_status != OfferStatus.PENDING.value:
            raise ValueError("Teklifin süresi dolmuş veya zaten yanıtlanmış.")

        offer_orm.status = new_status
        self.repo.commit()
        return self._to_schema(offer_orm)

    def get_offer_detail(self, offer_id: str) -> dict:
        offer_orm = self.repo.get_by_id(offer_id)
        if not offer_orm:
            raise KeyError("Teklif bulunamadı.")
        schema = self._to_schema(offer_orm)
        data = schema.model_dump()
        data["city"] = "İstanbul"
        data["note"] = "Şube: Sinanpaşa Mah."
        return data

