import sys
import os

# Ensure backend root directory is in sys.path for seamless package resolution
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config.database import Base, engine, SessionLocal
from app.services.seed_service import SeedService
from app.routes import auth_router

@asynccontextmanager
async def lifespan(app: FastAPI):

    # Create SQL database tables if they do not exist
    Base.metadata.create_all(bind=engine)

    # Trigger automatic data seeding if database is empty
    db = SessionLocal()
    try:
        SeedService.seed_data_if_empty(db)
    finally:
        db.close()

    yield

app = FastAPI(
    title="Vardigo Backend API",
    description="FastAPI REST API Service for Vardigo Case Study",
    version="1.0.0",
    lifespan=lifespan
)

# Enable CORS for local frontend connectivity
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register API Routers under /api
app.include_router(auth_router)


@app.get("/")
def read_root():
    return {"ok": True, "message": "Vardigo API Service Running"}