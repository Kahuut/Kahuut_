from typing import Optional
from uuid import UUID
from pydantic import BaseModel, Field

class Antwort(BaseModel):
    antwort: str
    richtig: Optional[bool] = False
    fk_ID_Frage: UUID
