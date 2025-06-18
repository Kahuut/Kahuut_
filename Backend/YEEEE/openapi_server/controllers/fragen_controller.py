"""
@package openapi_server.controllers
@brief Controller für die Verwaltung von Fragen
@details Ermöglicht das Hinzufügen von Fragen zu bestimmten Themen im Quiz-System.

"""

import connexion
from supabase import create_client, Client
from openapi_server.models.frage import Frage
from openapi_server.util import logger

# Supabase Zugangsdaten
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

from fastapi import HTTPException



def fragen_post(body) -> tuple:
    """! Fügt eine neue Frage zu einem Thema hinzu.

    @brief Erstellt eine neue Frage in der Datenbank
    @param body Die Frage-Daten
    @type body Frage
    @return Tuple mit Nachricht und HTTP-Statuscode
    @rtype tuple
    @retval ({"message": "Frage gespeichert"}, 201) bei Erfolg
    @retval ({"message": "Ungültige Eingabe"}, 400) bei ungültigen Daten
    @retval ({"message": "Fehler beim Speichern: ..."}, 500) bei Datenbankfehlern

    """
    try:
        if connexion.request.is_json:
            frage_data = Frage.parse_obj(connexion.request.get_json())

            # Daten vorbereiten
            daten = {
                "frage": frage_data.frage,
                "fk_id_themen": frage_data.fk_ID_Themen  # Genau auf Klein-/Großschreibung achten
            }

            # Insert in Supabase
            result = supabase.table("Fragen").insert(daten).execute()

            logger.info(f"Supabase result: {result}")

            # Zugriff auf die Felder
            if hasattr(result, "error") and result.error:
                logger.error(f"Fehler beim Speichern: {result.error}")
                return {"message": f"Fehler beim Speichern: {result.error}"}, 500

            logger.info("Frage erfolgreich gespeichert")
            return {"message": "Frage gespeichert"}, 201
        else:
            logger.warning("Ungültige Eingabe: Keine JSON-Daten")
            return {"message": "Ungültige Eingabe"}, 400
    except Exception as e:
        logger.exception(f"Exception beim Speichern: {e}")
        return {"message": f"Exception beim Speichern: {str(e)}"}, 500