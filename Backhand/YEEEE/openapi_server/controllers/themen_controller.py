from supabase import create_client, Client
import connexion
from typing import Dict, Tuple, Union, List
from openapi_server.models.thema import Thema  # dein Swagger Modell

SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# GET /themen
def themen_get(published=None) -> Union[List[Thema], Tuple[List[Thema], int], Tuple[List[Thema], int, Dict[str, str]]]:
    if published is not None:
        response = supabase.table("Themen").select("*").eq("published", published).execute()
    else:
        response = supabase.table("Themen").select("*").execute()

    themen_list = [Thema.from_dict(item) for item in response.data]
    return themen_list, 200

# POST /themen
def themen_post(body) -> Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]]:
    if connexion.request.is_json:
        thema = Thema.from_dict(connexion.request.get_json())

        # Thema in DB einfügen
        insert_data = {
            "titel": thema.titel,
            "beschreibung": thema.beschreibung,
            "published": thema.published
        }

        supabase.table("Themen").insert(insert_data).execute()
        return None, 201

    return {"message": "Ungültige Eingabe."}, 400
