from enum import Enum

class UserRole(str, Enum):
    EMPLOYER = "employer"
    WORKER = "worker"

class OfferStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    EXPIRED = "expired"

class CandidateTab(str, Enum):
    PERFECT = "perfect"
    SIMILAR = "similar"

class CandidateSort(str, Enum):
    RECOMMENDED = "recommended"
    NEAR = "near"
    RATING = "rating"
