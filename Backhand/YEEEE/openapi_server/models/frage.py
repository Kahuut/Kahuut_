# frage.py
from typing import Optional
from pydantic import BaseModel

class Frage(BaseModel):
    frage: str
    fk_ID_Themen: str
