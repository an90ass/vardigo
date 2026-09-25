from app.routes.auth_routes import router as auth_router
from app.routes.candidate_routes import router as candidate_router

__all__ = [
    "auth_router",
    "candidate_router"

]
