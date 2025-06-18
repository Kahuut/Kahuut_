"""
@package openapi_server.controllers
@brief Controller für die Mehrspieler-Funktionalität
@details Verwaltet das Starten und Beitreten von Mehrspieler-Quiz-Spielen.

"""

import connexion
from typing import Union, Tuple, Dict
from openapi_server.models.mehrspieler_join_post_request import MehrspielerJoinPostRequest  # noqa: E501
from openapi_server.models.mehrspieler_start_post_request import MehrspielerStartPostRequest  # noqa: E501
from supabase import create_client, Client
from openapi_server.util import logger

# Supabase Zugangsdaten
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def mehrspieler_start_post(body) -> Union[Dict, Tuple[Dict, int]]:
    """! Startet ein neues Mehrspieler-Quiz-Spiel.

    @brief Erstellt ein neues Mehrspieler-Spiel für ein öffentliches Thema
    @param body Die Start-Request-Daten
    @type body MehrspielerStartPostRequest
    @return Dictionary oder Tuple mit Nachricht und HTTP-Statuscode
    @rtype Union[Dict, Tuple[Dict, int]]
    @retval ({"message": "Spiel mit Code '...' wurde gestartet."}, 201) bei Erfolg
    @retval ({"message": "Ungültige Eingabe. JSON erwartet."}, 400) bei ungültigen Daten
    @retval ({"message": "Unauthorized - ..."}, 401) bei fehlender/ungültiger Authentifizierung
    @retval ({"message": "Kein öffentliches Thema mit diesem Code gefunden."}, 404) wenn Thema nicht existiert

    """
    try:
        if not connexion.request.is_json:
            return {"message": "Ungültige Eingabe. JSON erwartet."}, 400

        data = MehrspielerStartPostRequest.from_dict(connexion.request.get_json())
        code = data.code.strip()

        if not code:
            return {"message": "code darf nicht leer sein."}, 400

        auth_header = connexion.request.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Bearer "):
            return {"message": "Unauthorized - kein Token"}, 401

        token = auth_header.split(" ")[1]
        if token != "1234":
            return {"message": "Unauthorized - falscher Token"}, 401

        # Thema mit Code und public=True abfragen (public statt published!)
        thema_res = supabase.table("Themen").select("*").eq("code", code).eq("public", True).execute()
        themen = thema_res.data

        if not themen:
            return {"message": "Kein öffentliches Thema mit diesem Code gefunden."}, 404

        thema = themen[0]
        id_themen = thema["id_themen"]

        # Prüfen, ob Spiel mit dem Code schon existiert
        spiel_res = supabase.table("mehrspielerspiele").select("*").eq("code", code).execute()
        if spiel_res.data:
            return {"message": "Spiel mit diesem Code läuft bereits."}, 400

        # Neues Spiel anlegen
        spiel_data = {
            "code": code,
            "id_themen": id_themen,
            "status": "waiting",
            "players": []
        }
        supabase.table("mehrspielerspiele").insert(spiel_data).execute()

        return {"message": f"Spiel mit Code '{code}' wurde gestartet."}, 201

    except Exception as e:
        import traceback
        logger.error(f"Fehler beim Starten des Spiels: {e}")
        logger.error(traceback.format_exc())
        return {"message": f"Fehler beim Starten des Spiels: {str(e)}"}, 500


def mehrspieler_join_post(body) -> Union[Dict, Tuple[Dict, int]]:
    """! Fügt einen Spieler einem existierenden Mehrspieler-Spiel hinzu.

    @brief Lässt einen Spieler einem Mehrspieler-Spiel beitreten
    @param body Die Join-Request-Daten
    @type body MehrspielerJoinPostRequest
    @return Dictionary oder Tuple mit Nachricht und HTTP-Statuscode
    @rtype Union[Dict, Tuple[Dict, int]]
    @retval ({"message": "Spieler ... wurde hinzugefügt."}, 200) bei Erfolg
    @retval ({"message": "Neues Spiel erstellt. Spieler ... hinzugefügt."}, 201) wenn neues Spiel erstellt
    @retval ({"message": "Ungültige Eingabe. JSON erwartet."}, 400) bei ungültigen Daten
    @retval ({"message": "Spieler ist bereits im Spiel."}, 400) wenn Spieler bereits teilnimmt

    """
    try:
        if not connexion.request.is_json:
            return {"message": "Ungültige Eingabe. JSON erwartet."}, 400

        data = MehrspielerJoinPostRequest.from_dict(connexion.request.get_json())
        code = data.code.strip()
        id_user = data.user_id.strip()

        if not code or not id_user:
            return {"message": "Code und userId müssen gesetzt sein."}, 400

        # Thema mit Code abfragen
        thema_res = supabase.table("Themen").select("*").eq("code", code).execute()
        themen = thema_res.data

        if not themen:
            return {"message": "Kein Thema mit diesem Code gefunden."}, 404

        thema = themen[0]
        id_themen = thema["id_themen"]

        # Spiel mit Code abfragen
        spiel_res = supabase.table("mehrspielerspiele").select("*").eq("code", code).execute()
        spiele = spiel_res.data

        if not spiele:
            # Neues Spiel erstellen und Spieler hinzufügen
            supabase.table("mehrspielerspiele").insert({
                "code": code,
                "players": [id_user],
                "id_themen": id_themen,
                "status": "waiting"
            }).execute()
            return {"message": f"Neues Spiel erstellt. Spieler {id_user} hinzugefügt."}, 201

        spiel = spiele[0]
        players = spiel.get("players", [])

        if id_user in players:
            return {"message": "Spieler ist bereits im Spiel."}, 400

        players.append(id_user)
        supabase.table("mehrspielerspiele").update({
            "players": players
        }).eq("id", spiel["id"]).execute()

        return {"message": f"Spieler {id_user} wurde hinzugefügt."}, 200

    except Exception as e:
        import traceback
        logger.error(f"Fehler beim Spieler hinzufügen: {e}")
        logger.error(traceback.format_exc())
        return {"message": f"Fehler: {str(e)}"}, 500
