import connexion
from supabase import create_client, Client
from openapi_server.models.antwort import Antwort
from openapi_server.util import logger

# Supabase Zugangsdaten,
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def antworten_post(body) -> tuple:
    try:
        if connexion.request.is_json:
            antwort_data = Antwort.parse_obj(connexion.request.get_json())

            daten = {
                "antwort": antwort_data.antwort,
                "richtig": antwort_data.richtig or False,
                "fk_id_frage": str(antwort_data.fk_ID_Frage)  # UUID zu String konvertieren!
            }

            result = supabase.table("Antworten").insert(daten).execute()

            logger.info(f"Supabase result: {result}")

            if hasattr(result, "error") and result.error:
                logger.error(f"Fehler beim Speichern: {result.error}")
                return {"message": f"Fehler beim Speichern: {result.error}"}, 500

            return {"message": "Antwort gespeichert"}, 201
        else:
            logger.warning("Ungültige Eingabe: Keine JSON-Daten")
            return {"message": "Ungültige Eingabe"}, 400
    except Exception as e:
        logger.exception(f"Exception beim Speichern: {e}")
        return {"message": f"Exception beim Speichern: {str(e)}"}, 500

