from app.dependencies.database_deps import get_db
from app.dependencies.auth_deps import get_auth_service, get_current_user_role
from app.dependencies.candidate_deps import get_candidate_repository, get_candidate_service

__all__ = [
    "get_db",
    "get_auth_service",
    "get_current_user_role",
    "get_candidate_repository",
    "get_candidate_service",

]
