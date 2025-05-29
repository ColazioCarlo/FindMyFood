from flask import Blueprint, request, jsonify, current_app
from werkzeug.security import generate_password_hash, check_password_hash
import datetime
import jwt

from extensions import db 
from models.user import User
from models.refresh_token import RefreshToken
from utils.auth_utils import generate_access_token, generate_refresh_token

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=["POST"])
def register():
    data = request.get_json()

    if not data or not data.get("username") or not data.get("password"):
        return jsonify({"message": "Username and password are required"}), 400

    username = data["username"]
    password = data["password"]
    
    # Provjera je li korisnik vec u bazi
    if User.query.filter_by(username=username).first():
        return jsonify({"message": "User already exists"}), 409

    # Hashaj lozinku pomocu generate_password_hash
    hashed_password = generate_password_hash(password, method="pbkdf2:sha256")

    # Kreiraj novog korisnika s hashanom lozinkom tre dodaj u bazu
    new_user = User(username=username, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

# Vraca token response na rutu ako su credentialsi dobri
@auth_bp.route("/login", methods=["POST"])
def login():
    auth = request.get_json()

    if not auth or not auth.get("username") or not auth.get("password"):
        return jsonify({"message": "Could not verify"}), 400

    username = auth["username"]
    password = auth["password"]
    
    # Query za korisnika u MySQL bazi s danim usernameom
    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password, password):

        # Generiranje access i refresh tokena za uspjesno prijavljenog korisnika
        access_token = generate_access_token(user)
        refresh_token = generate_refresh_token(user)

        return jsonify(
            {"access_token": access_token, "refresh_token": refresh_token}
        ), 200

    return jsonify({"message": "Invalid credentials"}), 401

@auth_bp.route("/refresh", methods=["POST"])
def refresh():
    data = request.get_json()
    refresh_token = data.get("refresh_token")
    if not refresh_token:
        return jsonify({"message": "Refresh token is required"}), 401

    try:
        payload = jwt.decode(
            refresh_token, current_app.config["REFRESH_SECRET_KEY"], algorithms=["HS256"]
        )
        user_id = payload["user_id"]

        # Dohvacanje korisnika iz baze na temelju ID-a
        current_user = User.query.get(user_id)
        
        # Provjera postoji li korisnik s tim ID
        if not current_user:
            return jsonify({"message": "Invalid refresh token"}), 401

        refresh_db_token = RefreshToken.query.filter_by(
            token=refresh_token, user_id=user_id
        ).first()

        # Postoji li dani refresh token u bazi i je li istekao
        if not refresh_db_token:
            return jsonify({"message": "Refresh token doesn't exist"}), 401

        expiry_date = refresh_db_token.expiry_date
        
        if expiry_date.tzinfo is None:
            expiry_date = expiry_date.replace(tzinfo=datetime.timezone.utc)

        if expiry_date < datetime.datetime.now(datetime.timezone.utc):
            if refresh_db_token:
                db.session.delete(refresh_db_token)
                db.session.commit()
            return jsonify({"message": "Expired refresh token"}), 401	

        access_token = generate_access_token(current_user)
        # iz sigurnosnih razloga - brisanje starog refresh tokena
        db.session.delete(refresh_db_token)
        db.session.commit()
        new_refresh_token = generate_refresh_token(current_user)

        return jsonify(
            {"access_token": access_token, "refresh_token": new_refresh_token}
        ), 200

    except jwt.ExpiredSignatureError:
        # Ako je refresh token istekao, brise se iz baze podataka ako postoji.
        refresh_db_token = RefreshToken.query.filter_by(token=refresh_token).first()
        if refresh_db_token:
            db.session.delete(refresh_db_token)
            db.session.commit()
        return jsonify({"message": "Refresh token expired!"}), 401
    # Hvatanje ostalih iznimki vezanih uz nevazeci refresh token
    except (jwt.InvalidTokenError, Exception) as e:
        return jsonify({"message": f"Invalid refresh token! {e}"}), 401
