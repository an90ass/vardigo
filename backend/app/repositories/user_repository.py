from typing import List, Optional
from sqlalchemy.orm import Session
from app.models import UserORM, UserRole
from app.repositories.base import BaseRepository

class UserRepository(BaseRepository[UserORM]):

    def __init__(self, db: Session):
        super().__init__(db)

    def get_by_id(self, entity_id: str) -> Optional[UserORM]:
        return self.db.query(UserORM).filter(UserORM.id == entity_id).first()

    def get_all(self) -> List[UserORM]:
        return self.db.query(UserORM).all()

    def get_by_role(self, role: UserRole) -> Optional[UserORM]:
        return self.db.query(UserORM).filter(UserORM.role == role).first()

    def get_by_token(self, token: str) -> Optional[UserORM]:
        return self.db.query(UserORM).filter(UserORM.token == token).first()

    def add(self, user: UserORM) -> UserORM:
        self.db.add(user)
        return user

    def commit(self) -> None:
        self.db.commit()
