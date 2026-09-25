from app.dependencies.database_deps import get_db
from app.dependencies.auth_deps import (
    get_auth_service,
    get_current_user_role,
    require_employer,
    require_worker
)
from app.dependencies.candidate_deps import get_candidate_repository, get_candidate_service
from app.dependencies.offer_deps import get_offer_repository, get_offer_service

__all__ = [
    "get_db",
    "get_auth_service",
    "get_current_user_role",
    "require_employer",
    "require_worker",
    "get_candidate_repository",
    "get_candidate_service",
    "get_offer_repository",
    "get_offer_service"
]
