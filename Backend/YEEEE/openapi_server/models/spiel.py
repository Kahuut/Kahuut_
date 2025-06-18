from datetime import date, datetime  # noqa: F401

from typing import List, Dict  # noqa: F401

from openapi_server.models.base_model import Model
from openapi_server import util
from openapi_server.util import logger

class Spiel:
    def __init__(self, id=None, name=None):
        if id is None:
            logger.warning("Spiel: Instanz ohne ID erstellt")
        if name is None:
            logger.warning("Spiel: Instanz ohne Name erstellt")
        self.id = id
        self.name = name
        logger.info(f"Spiel erstellt: ID={id}, Name={name}")
    
    def validate(self):
        if not self.id:
            logger.error("Spiel: Validierung fehlgeschlagen - keine ID")
            raise ValueError("Spiel ID darf nicht leer sein")
        if not self.name:
            logger.error("Spiel: Validierung fehlgeschlagen - kein Name")
            raise ValueError("Spiel Name darf nicht leer sein")
        return True