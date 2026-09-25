from app.repositories.base import BaseRepository
from app.repositories.candidate_repository import CandidateRepository
from app.repositories.offer_repository import OfferRepository
from app.repositories.user_repository import UserRepository

__all__ = [
    "BaseRepository",
    "CandidateRepository",
    "OfferRepository",
    "UserRepository"
]
