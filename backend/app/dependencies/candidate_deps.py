from fastapi import Depends
from sqlalchemy.orm import Session
from app.dependencies.database_deps import get_db
from app.repositories.candidate_repository import CandidateRepository
from app.services.candidate_service import CandidateService

def get_candidate_repository(db: Session = Depends(get_db)) -> CandidateRepository:
    return CandidateRepository(db)

def get_candidate_service(
    repo: CandidateRepository = Depends(get_candidate_repository)
) -> CandidateService:
    return CandidateService(repo)
