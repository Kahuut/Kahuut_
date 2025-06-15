import connexion
from supabase import create_client, Client
from openapi_server.models.frage import Frage

# Supabase Zugangsdaten
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

from fastapi import HTTPException



def fragen_post(body) -> tuple:
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

            # Debug: Print das komplette Ergebnis
            print("Supabase result:", result)

            # Zugriff auf die Felder
            if hasattr(result, "error") and result.error:
                return {"message": f"Fehler beim Speichern: {result.error}"}, 500

            return {"message": "Frage gespeichert"}, 201
        else:
            return {"message": "Ungültige Eingabe"}, 400
    except Exception as e:
        print(f"Exception beim Speichern: {e}")
        return {"message": f"Exception beim Speichern: {str(e)}"}, 500