import uuid
from sqlalchemy import Column, String, Integer, Float, Boolean
from sqlalchemy.orm import relationship
from app.config.database import Base

class CandidateORM(Base):

    __tablename__ = "candidates"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    name = Column(String, nullable=False)
    rating = Column(String, nullable=False)
    attend = Column(String, nullable=False)
    km = Column(String, nullable=False)
    kmValue = Column(Float, nullable=False)
    photo = Column(String, nullable=False)
    online = Column(Boolean, default=True)
    perfect = Column(Boolean, default=False)
    score = Column(Integer, nullable=False)

    # Relationship: One Candidate has Many Offers sent to them
    offers = relationship("OfferORM", back_populates="candidate", cascade="all, delete-orphan")
