import os
import json
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List
from sqlalchemy.orm import Session
from app.models import UserORM, CandidateORM, OfferORM, UserRole, OfferStatus
from app.repositories.candidate_repository import CandidateRepository
from app.repositories.offer_repository import OfferRepository

class SeedService:

    @classmethod
    def seed_data_if_empty(cls, db: Session) -> None:

        candidate_repo = CandidateRepository(db)
        offer_repo = OfferRepository(db)

        # Check if database is already populated
        if len(candidate_repo.get_all()) > 0:
            return

        seed_data = cls._load_seed_json()
        if not seed_data:
            return

        # Execute seeding steps sequentially
        cls._seed_users(db, seed_data.get("users", []))
        cls._seed_candidates(candidate_repo, seed_data.get("candidates", []))
        cls._seed_offers(offer_repo, seed_data.get("offers", []))

        # Persist seeded data
        offer_repo.commit()

    @staticmethod
    def _load_seed_json() -> Dict[str, Any]:

        seed_path = os.path.join(os.path.dirname(__file__), "..", "seed", "seed.json")
        if not os.path.exists(seed_path):
            return {}

        with open(seed_path, "r", encoding="utf-8") as f:
            return json.load(f)

    @staticmethod
    def _seed_users(db: Session, users_data: List[Dict[str, Any]]) -> None:

        for u in users_data:
            db.add(UserORM(
                id=u["id"],
                role=UserRole(u["role"]),
                name=u["name"],
                token=u["token"]
            ))

    @staticmethod
    def _seed_candidates(candidate_repo: CandidateRepository, candidates_data: List[Dict[str, Any]]) -> None:

        for c in candidates_data:
            candidate_repo.add(CandidateORM(
                id=c["id"],
                name=c["name"],
                rating=c["rating"],
                attend=c["attend"],
                km=c["km"],
                kmValue=c["kmValue"],
                photo=c["photo"],
                online=c["online"],
                perfect=c["perfect"],
                score=c["score"]
            ))

    @classmethod
    def _seed_offers(cls, offer_repo: OfferRepository, offers_data: List[Dict[str, Any]]) -> None:

        for o in offers_data:
            # Parse relative expiration keywords
            exp_str = cls._parse_expiration(o.get("expiresAt"))
            offer_repo.add(OfferORM(
                id=o["id"],
                worker_id=o["workerId"],
                title=o["title"],
                place=o["place"],
                pay=o["pay"],
                payValue=o["payValue"],
                logo=o["logo"],
                district=o["district"],
                when_time=o["when"],
                status=OfferStatus(o["status"]),
                expiresAt=exp_str
            ))

    @staticmethod
    def _parse_expiration(expires_at_raw: str) -> str:

        now = datetime.now(timezone.utc)
        if expires_at_raw == "USE_NOW_PLUS_21H32M":
            return (now + timedelta(hours=21, minutes=32)).isoformat()
        elif expires_at_raw == "USE_NOW_PLUS_18H00M":
            return (now + timedelta(hours=18, minutes=0)).isoformat()
        return expires_at_raw or now.isoformat()
