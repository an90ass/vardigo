from abc import ABC, abstractmethod
from typing import Generic, TypeVar, List, Optional
from sqlalchemy.orm import Session

T = TypeVar("T")

class BaseRepository(ABC, Generic[T]):

    def __init__(self, db: Session):
        self.db = db

    @abstractmethod
    def get_by_id(self, entity_id: str) -> Optional[T]:
        pass

    @abstractmethod
    def get_all(self) -> List[T]:
        pass
