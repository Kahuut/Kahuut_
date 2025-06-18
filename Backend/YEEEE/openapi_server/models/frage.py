# frage.py
from typing import Optional
from pydantic import BaseModel, validator
from openapi_server.util import logger

class Frage(BaseModel):
    frage: str
    fk_ID_Themen: str
    
    @validator('frage')
    def validate_frage(cls, v):
        if not v:
            logger.error("Frage: Versuch eine leere Frage zu setzen")
            raise ValueError("Die Frage darf nicht leer sein")
        return v
        
    @validator('fk_ID_Themen')
    def validate_thema_id(cls, v):
        if not v:
            logger.error("Frage: Versuch ein leeres fk_ID_Themen zu setzen")
            raise ValueError("fk_ID_Themen darf nicht leer sein")
        return v
