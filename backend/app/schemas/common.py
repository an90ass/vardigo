from pydantic import BaseModel, ConfigDict
from typing import Optional, Generic, TypeVar

T = TypeVar("T")

class ErrorDetail(BaseModel):
    code: str
    message: str

class ApiResponse(BaseModel, Generic[T]):
    model_config = ConfigDict(extra="ignore")
    ok: bool = True
    data: Optional[T] = None
    error: Optional[ErrorDetail] = None

    def model_dump(self, **kwargs):
        kwargs.setdefault("exclude_none", True)
        return super().model_dump(**kwargs)
