import uuid
from sqlalchemy import Column, String, Integer, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship
from app.config.database import Base
from app.models.enums import OfferStatus

class OfferORM(Base):
    __tablename__ = "offers"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    worker_id = Column(String, ForeignKey("candidates.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    place = Column(String, nullable=False)
    pay = Column(String, nullable=False)
    payValue = Column(Integer, nullable=False)
    logo = Column(String, nullable=False)
    district = Column(String, nullable=False)
    when_time = Column(String, nullable=False)
    status = Column(SQLEnum(OfferStatus, native_enum=False), nullable=False, default=OfferStatus.PENDING, index=True)
    expiresAt = Column(String, nullable=False)

    # Relationship: Offer belongs to a Candidate
    candidate = relationship("CandidateORM", back_populates="offers")
