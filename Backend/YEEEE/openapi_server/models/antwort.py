from typing import Optional
from uuid import UUID
from pydantic import BaseModel, Field, validator
from openapi_server.util import logger

class Antwort(BaseModel):
    antwort: str
    richtig: Optional[bool] = False
    fk_ID_Frage: UUID
    
    @validator('antwort')
    def validate_antwort(cls, v):
        if not v:
            logger.error("Antwort: Versuch eine leere Antwort zu setzen")
            raise ValueError("Die Antwort darf nicht leer sein")
        return v
        
    @validator('fk_ID_Frage')
    def validate_frage_id(cls, v):
        if not v:
            logger.error("Antwort: Versuch eine leere fk_ID_Frage zu setzen")
            raise ValueError("fk_ID_Frage darf nicht leer sein")
        return v
