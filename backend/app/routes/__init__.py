from app.routes.auth_routes import router as auth_router
from app.routes.candidate_routes import router as candidate_router
from app.routes.offer_routes import router as offer_router
__all__ = [
    "auth_router",
    "candidate_router",
    "offer_router"

]
