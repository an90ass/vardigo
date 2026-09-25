import uuid
from sqlalchemy import Column, String, Enum as SQLEnum
from app.config.database import Base
from app.models.enums import UserRole

class UserORM(Base):

    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    role = Column(SQLEnum(UserRole, native_enum=False), nullable=False)
    name = Column(String, nullable=False)
    token = Column(String, nullable=False, unique=True)
