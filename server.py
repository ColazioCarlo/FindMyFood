from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime
from functools import wraps
import os
import requests
import json

app = Flask(__name__)

# u .env kasnije, moze biti bilo sto jer se hashira
app.config["SECRET_KEY"] = (
    "aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ=="
)

app.config["REFRESH_SECRET_KEY"] = "brochacho75ts"

# Postavljanje URI-ja za spajanje na MySQL bazu podataka.
# Updateat URI po vlastitim MySQL credentialsima i imenom baze podataka
app.config["SQLALCHEMY_DATABASE_URI"] = (
    "mysql+pymysql://FindMyFood:findmyfood@localhost/FindMyFood"
)

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
ACCESS_TOKEN_LIFETIME = datetime.timedelta(minutes=30)
REFRESH_TOKEN_LIFETIME = datetime.timedelta(days=7)

GOOGLE_MAPS_API_KEY = "AIzaSyBaP9v66ys9ZFzUcf1rYkopaOKmDKapkNU"

# Inicijalizacija SQLAlchemy instance za rad s bazom podataka.
db = SQLAlchemy(app)


# Definiran User model za pohranu korisničkih podataka u MySQL bazi podataka.
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    # Relacija s RefreshToken modelom. Jedan korisnik može imati vise refresh tokena.
    refresh_tokens = db.relationship("RefreshToken", backref="user", lazy=True)

    def __repr__(self):
        return f"<User {self.username}>"

class BusinessUser(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=True)
    phone = db.Column(db.String(50), nullable=True)
    address = db.Column(db.String(255), nullable=False)
    parkingtotal = db.Column(db.Integer, nullable=True)
    parkingfree = db.Column(db.Integer, nullable=True)
    opis = db.Column(db.Text, nullable=True)
    google_place_id = db.Column(db.String(50), unique=True, nullable=True)

    def __repr__(self):
        return f"<PoslovniUser {self.username}>"


# Definiran RefreshToken model za pohranu refresh tokena u bazi podataka.
class RefreshToken(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(255), unique=True, nullable=False)

    # Strani ključ koji povezuje refresh token s korisnikom.
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # Datum isteka refresh tokena.
    expiry_date = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<RefreshToken {self.token}>"


# Funkcija za generiranje access tokena za danog korisnika.
def generate_access_token(user):
    payload = {
        "user_id": user.id,
        "exp": datetime.datetime.now(datetime.timezone.utc) + ACCESS_TOKEN_LIFETIME,
    }
    return jwt.encode(payload, app.config["SECRET_KEY"], algorithm="HS256")


# Funkcija za generiranje refresh tokena za danog korisnika i pohranu u bazu podataka.
def generate_refresh_token(user):
    payload = {
        "user_id": user.id,
        "exp": datetime.datetime.now(datetime.timezone.utc) + REFRESH_TOKEN_LIFETIME,
    }
    refresh_token = jwt.encode(
        payload, app.config["REFRESH_SECRET_KEY"], algorithm="HS256"
    )
    # Stvaranje instance RefreshToken modela za pohranu u bazu podataka.
    db_token = RefreshToken(
        token=refresh_token, user_id=user.id, expiry_date=payload["exp"]
    )
    # Dodavanje novog refresh tokena u sesiju baze podataka.
    db.session.add(db_token)
    # Potvrđivanje promjena u bazi podataka.
    db.session.commit()
    return refresh_token


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get("Authorization")
        if not token:
            return jsonify({"message": "Authorization header is missing"}), 401

        if not token.startswith("Bearer "):
            return jsonify({"message": "Invalid token format"}), 401

        token = token.split(" ")[1]

        try:
            data = jwt.decode(token, app.config["SECRET_KEY"], algorithms=["HS256"])
            current_user = User.query.get(data["user_id"])
            if current_user is None:
                return jsonify({"message": "Invalid token"}), 401
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Access token expired!"}), 401
        except (jwt.InvalidTokenError, Exception):
            return jsonify({"message": "Invalid access token!"}), 401

        return f(current_user, *args, **kwargs)

    return decorated


@app.route("/register", methods=["POST"])
def register():
    # Primi JSON podatke iz requesta
    data = request.get_json()

    if not data or not data.get("username") or not data.get("password"):
        return jsonify({"message": "Username and password are required"}), 400

    username = data["username"]
    password = data["password"]

    # Provjera je li korisnik vec u bazi podataka
    if User.query.filter_by(username=username).first():
        return jsonify({"message": "User already exists"}), 409

    # Hashaj lozinku pomocu generate_password_hash
    hashed_password = generate_password_hash(password, method="pbkdf2:sha256")

    # Kreiraj novog korisnika s hashanom lozinkom te dodaj u bazu
    new_user = User(username=username, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201


# Vraca token response na rutu ako su credentialsi dobri
@app.route("/login", methods=["POST"])
def login():
    auth = request.get_json()

    if not auth or not auth.get("username") or not auth.get("password"):
        return jsonify({"message": "Could not verify"}), 400

    username = auth["username"]
    password = auth["password"]

    # Query za korisnika u MySQL bazi s danim usernameom
    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password, password):
        # Generiranje access tokena za uspješno prijavljenog korisnika.
        access_token = generate_access_token(user)

        # Generiranje refresh tokena za uspješno prijavljenog korisnika.
        refresh_token = generate_refresh_token(user)

        return jsonify(
            {"access_token": access_token, "refresh_token": refresh_token}
        ), 200

    return jsonify({"message": "Invalid credentials"}), 401


@app.route("/refresh", methods=["POST"])
def refresh():
    data = request.get_json()
    refresh_token = data.get("refresh_token")
    if not refresh_token:
        return jsonify({"message": "Refresh token is required"}), 401

    try:
        # print(f"Received refresh token: {refresh_token}")  # Debugging line
        payload = jwt.decode(
            refresh_token, app.config["REFRESH_SECRET_KEY"], algorithms=["HS256"]
        )
        user_id = payload["user_id"]
        # print(f"Decoded user ID: {user_id}")  # Debugging line
        # Dohvacanje korisnika iz baze podataka na temelju ID-a.
        current_user = User.query.get(user_id)
        # Provjera postoji li korisnik s tim ID.
        if not current_user:
            return jsonify({"message": "Invalid refresh token"}), 401

        # Provjera postoji li dani refresh token u bazi podataka za tog korisnika i je li istekao.
        refresh_db_token = RefreshToken.query.filter_by(
            token=refresh_token, user_id=user_id
        ).first()
        if not refresh_db_token or refresh_db_token.expiry_date < datetime.datetime.now(datetime.timezone.utc).replace(tzinfo=None):
            # Ako refresh token ne postoji ili je istekao, brise se iz baze podataka ako postoji.
            if refresh_db_token:
                db.session.delete(refresh_db_token)
                db.session.commit()
            return jsonify({"message": "Invalid or expired refresh token"}), 401

        # Generiranje novog access tokena za trenutnog korisnika.
        access_token = generate_access_token(current_user)
        # Generiranje novog refresh tokena za trenutnog korisnika.
        new_refresh_token = generate_refresh_token(current_user)
        # Vracanje novog access i refresh tokena u JSON odgovoru.
        return jsonify(
            {"access_token": access_token, "refresh_token": new_refresh_token}
        ), 200
    # Hvatanje iznimke ako je potpis refresh tokena istekao.
    except jwt.ExpiredSignatureError:
        # print(f"Expired refresh token: {refresh_token}")  # Debugging line
        # Ako je refresh token istekao, brise se iz baze podataka ako postoji.
        refresh_db_token = RefreshToken.query.filter_by(token=refresh_token).first()
        if refresh_db_token:
            db.session.delete(refresh_db_token)
            db.session.commit()
        return jsonify({"message": "Refresh token expired!"}), 401
    # Hvatanje ostalih iznimki vezanih uz nevazeci refresh token.
    except jwt.InvalidTokenError as e:
        # print(f"Invalid token error: {str(e)}")
        return jsonify({"message": "Invalid refresh token!"}), 401

# Query Google Places API to get the Place ID for the given address
def get_place_id(address):
    url = "https://places.googleapis.com/v1/places:searchText"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
        "X-Goog-FieldMask": "places.id"
    }
    payload = {
        "textQuery": address
    }

    response = requests.post(url, headers=headers, json=payload)
    data = response.json()

    if response.status_code == 200 and "places" in data and data["places"]:
        return data["places"][0]["id"]
    return None


@app.route("/registerposlovni", methods=["POST"])
def register_poslovni():
    data = request.get_json()

    # Validate input data
    required_fields = ["username", "password", "name", "email", "phone", "address", "parking", "opis"]
    if not all(field in data for field in required_fields):
        return jsonify({"message": "All fields are required"}), 400

    # Check if username or email already exists
    if BusinessUser.query.filter_by(username=data["username"]).first() or BusinessUser.query.filter_by(email=data["email"]).first():
        return jsonify({"message": "Username or email already exists"}), 409

    # Hash password
    hashed_password = generate_password_hash(data["password"], method="pbkdf2:sha256")

    # Fetch Place ID from Google Places API
    # Ukoliko nije moguce pronaci mjesto na mapi, funkcija vraca null. Zasad dozvoljavamo i mjesta koja nisu dostupna na mapsu, ali to se moze zabraniti provjerom:
    google_place_id = get_place_id(data["address"])

    # if not google_place_id:
        # return jsonify({"message": "Could not find a valid Google Maps place ID for this address"}), 400

    # Create a new business user
    new_business = BusinessUser(
        username=data["username"],
        password=hashed_password,
        name=data["name"],
        email=data["email"],
        phone=data["phone"],
        address=data["address"],
        parkingtotal=int(data["parking"]),
        parkingfree=int(data["parking"]),
        opis=data["opis"],
        google_place_id=google_place_id
    )

    db.session.add(new_business)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

# Logged in ruta s tokenom, vraca osnovni hello world
@app.route("/protected", methods=["GET"])
@token_required
def protected(current_user):
    return jsonify({"message": f"Hello world {current_user.username}"})


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True, host="0.0.0.0", port=8080)
