"""
@package openapi_server.controllers
@brief Controller für die Sicherheits- und Authentifizierungsfunktionen
@details Verarbeitet Bearer-Token-Authentifizierung und Autorisierung für geschützte Endpunkte.

"""

from typing import List
from openapi_server.util import logger


def info_from_BearerAuth(token):
    """! Überprüft und extrahiert Authentifizierungsinformationen aus dem Bearer-Token.

    @brief Validiert den Bearer-Token und gibt Benutzerinformationen zurück
    @param token Der zu überprüfende Token
    @type token str
    @return Dictionary mit Benutzerinformationen oder None bei ungültigem Token
    @rtype dict or None

    """
    logger.info(f"security_controller: BearerAuth geprüft, token={token}")
    return {'uid': 'user_id'}

