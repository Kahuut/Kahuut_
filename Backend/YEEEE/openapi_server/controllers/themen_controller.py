"""
@package openapi_server.controllers
@brief Controller für die Verwaltung von Quiz-Themen
@details Ermöglicht das Erstellen und Abrufen von Quiz-Themen, mit Unterstützung für öffentliche und private Themen.

"""

import json
import random
import string
from supabase import create_client, Client
import connexion
from openapi_server.models.thema import Thema
from typing import Union, Tuple, Dict
from openapi_server.util import logger

# Supabase Zugangsdaten
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def generate_code(length: int = 5) -> str:
    """! Generiert einen zufälligen Code für ein Thema.

    @brief Erstellt einen zufälligen Code aus Großbuchstaben und Zahlen
    @param length Länge des zu generierenden Codes
    @type length int
    @return Der generierte Code
    @rtype str

    """
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))



def themen_get(public=None):
    """! Ruft alle Themen ab, optional gefiltert nach öffentlichen Themen.

    @brief Gibt eine Liste aller Themen zurück
    @param public Optional: Filter für öffentliche Themen
    @type public bool or None
    @return Liste von Themen und HTTP-Statuscode
    @rtype tuple
    @retval (themen_list, 200) bei Erfolg
    @retval ({"message": "Fehler beim Abrufen: ..."}, 500) bei Datenbankfehlern

    """
    try:
        # Query-Parameter normalisieren
        if public is not None:
            if isinstance(public, str):
                public = public.lower() == 'true'
            response = supabase.table("Themen").select("*").eq("public", public).execute()
        else:
            response = supabase.table("Themen").select("*").execute()

        logger.info(f"GET Ergebnis: {response.data}")

        # Konvertiere Daten zu Thema-Objekten
        themen_list = []
        for item in response.data:
            thema = Thema(
                name=item.get("name"),
                code=item.get("code"),
                published=item.get("public", False)
            )
            themen_list.append(thema.to_dict())

        return themen_list, 200

    except Exception as e:
        logger.exception(f"Fehler beim Abrufen: {e}")
        return {"message": f"Fehler beim Abrufen: {str(e)}"}, 500



def themen_post(body) -> Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]]:
    """! Erstellt ein neues Quiz-Thema.

    @brief Fügt ein neues Thema in die Datenbank ein (nur für Admins)
    @param body Die Themen-Daten
    @type body Thema
    @return None oder Tuple mit Status und optionaler Fehlermeldung
    @rtype Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]]
    @retval (None, 201) bei Erfolg
    @retval ({"message": "Unauthorized - ..."}, 401) bei fehlender/ungültiger Authentifizierung

    """
    # Authorization prüfen
    auth_header = connexion.request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return {"message": "Unauthorized - kein Token"}, 401

    token = auth_header.split(" ")[1]
    if token != "1234":
        return {"message": "Unauthorized - falscher Token"}, 401

    # JSON prüfen
    if not connexion.request.is_json:
        return {"message": "Ungültige Eingabe"}, 400

    data = connexion.request.get_json()

    name = data.get("name")
    code = data.get("code")
    # Aus dem Request kommt 'published', wir wandeln in 'public' um:
    public = data.get("published", False)

    if not name or not code:
        return {"message": "Name und Code müssen gesetzt sein."}, 400

    insert_data = {
        "name": name,
        "code": code,
        "public": public
    }

    try:
        res = supabase.table("Themen").insert(insert_data).execute()
        logger.info(f"Insert Ergebnis: {res.data}")
        # Kein Zugriff auf status_code oder error — Exception wird geworfen bei Fehlern
        return None, 201
    except Exception as e:
        logger.exception(f"Exception beim Speichern: {str(e)}")
        return {"message": f"Fehler beim Speichern: {str(e)}"}, 500
