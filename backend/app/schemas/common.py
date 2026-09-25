from pydantic import BaseModel
from typing import Optional, Generic, TypeVar

T = TypeVar("T")

class ErrorDetail(BaseModel):
    code: str
    message: str

class ApiResponse(BaseModel, Generic[T]):
    ok: bool = True
    data: Optional[T] = None
    error: Optional[ErrorDetail] = None
