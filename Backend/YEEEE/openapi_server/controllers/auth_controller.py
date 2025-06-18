import connexion
import bcrypt
from typing import Dict, Tuple, Union

from openapi_server.models.login import Login
from openapi_server.models.register_admin import RegisterAdmin
from openapi_server.models.register_user import RegisterUser
from supabase import create_client, Client
from openapi_server.util import logger

# Supabase Zugangsdaten
SUPABASE_URL = "https://bhgvyhekvowmwirfklih.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoZ3Z5aGVrdm93bXdpcmZrbGloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTY5NzUsImV4cCI6MjA2NDc3Mjk3NX0.Y5y6FJOSxy2NMRvfRpvTVVloWdxPL0P51cgGVdmz0nU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# 🔐 Passwort-Hashing
def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode("utf-8"), hashed.encode("utf-8"))

# 🧑‍💼 Admin registrieren
def auth_admin_register_post(body) -> Union[Dict, Tuple[Dict, int]]:
    if connexion.request.is_json:
        register_admin = RegisterAdmin.from_dict(connexion.request.get_json())

        existing = supabase.table("Admin").select("*").eq("email", register_admin.email).execute()
        if existing.data:
            logger.warning(f"Registrierung Admin fehlgeschlagen: {register_admin.email} existiert bereits.")
            return {"message": "Admin existiert bereits."}, 409

        hashed_pw = hash_password(register_admin.password)

        supabase.table("Admin").insert({
            "name": register_admin.name,
            "email": register_admin.email,
            "password": hashed_pw
        }).execute()

        logger.info(f"Admin erfolgreich registriert: {register_admin.email}")
        return {"message": "Admin erfolgreich registriert."}, 201
    logger.warning("Ungültige Eingabe bei Admin-Registrierung.")
    return {"message": "Ungültige Eingabe."}, 400

# 👤 User registrieren
def auth_user_register_post(body) -> Union[Dict, Tuple[Dict, int]]:
    if connexion.request.is_json:
        register_user = RegisterUser.from_dict(connexion.request.get_json())

        existing = supabase.table("User").select("*").eq("email", register_user.email).execute()
        if existing.data:
            logger.warning(f"Registrierung User fehlgeschlagen: {register_user.email} existiert bereits.")
            return {"message": "User existiert bereits."}, 409

        hashed_pw = hash_password(register_user.password)

        supabase.table("User").insert({
            "name": register_user.name,
            "email": register_user.email,
            "password": hashed_pw
        }).execute()

        logger.info(f"User erfolgreich registriert: {register_user.email}")
        return {"message": "User erfolgreich registriert."}, 201
    logger.warning("Ungültige Eingabe bei User-Registrierung.")
    return {"message": "Ungültige Eingabe."}, 400

# 🔑 Login
def auth_login_post(body) -> Union[Dict, Tuple[Dict, int]]:
    if connexion.request.is_json:
        login = Login.from_dict(connexion.request.get_json())

        # Admin prüfen
        admin = supabase.table("Admin").select("*").eq("email", login.email).execute()
        if admin.data:
            admin_data = admin.data[0]
            if verify_password(login.password, admin_data["password"]):
                logger.info(f"Admin Login erfolgreich: {login.email}")
                return {"message": "Admin Login erfolgreich."}, 200
            else:
                logger.warning(f"Admin Login fehlgeschlagen (falsches Passwort): {login.email}")
                return {"message": "Falsches Passwort."}, 401

        # User prüfen
        user = supabase.table("User").select("*").eq("email", login.email).execute()
        if user.data:
            user_data = user.data[0]
            if verify_password(login.password, user_data["password"]):
                logger.info(f"User Login erfolgreich: {login.email}")
                return {"message": "User Login erfolgreich."}, 200
            else:
                logger.warning(f"User Login fehlgeschlagen (falsches Passwort): {login.email}")
                return {"message": "Falsches Passwort."}, 401

        logger.warning(f"Login fehlgeschlagen: Benutzer nicht gefunden: {login.email}")
        return {"message": "Benutzer nicht gefunden."}, 404
    logger.warning("Ungültige Eingabe beim Login.")
    return {"message": "Ungültige Eingabe."}, 400
