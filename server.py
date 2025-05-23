from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime
from functools import wraps
import requests
import json

app = Flask(__name__)

# u .env kasnije, moze biti bilo sto jer se hashira
app.config['SECRET_KEY'] = 'aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ=='

# Updateat URI po vlastitim MySQL credentialsima i imenom baze podataka
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://FindMyFood:findmyfood@localhost/FindMyFood'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

GOOGLE_MAPS_API_KEY = "AIzaSyBaP9v66ys9ZFzUcf1rYkopaOKmDKapkNU"

# Inicijalizacija baze podataka
db = SQLAlchemy(app)

# Definiran User model za pohranu credentialsa u MySQL.
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)  # Kasnije implementirati hashanje

    def __repr__(self):
        return f'<User {self.username}>'

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

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Token')
        if not token:
            return jsonify({'message': 'Token was not provided'}), 401
        try:
            if 'bearer_' in token.lower():
                token = token.replace('Bearer_','').replace('bearer_','')
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
            current_user = data['user']
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token expired!'}), 401
        except (jwt.InvalidTokenError, Exception):
            return jsonify({'message': 'Token is invalid!'}), 401

        return f(current_user, *args, **kwargs)
    return decorated

@app.route('/register', methods=['POST'])
def register():
    # Primi JSON podatke iz requesta
    data = request.get_json()

    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'message': 'Username and password are required'}), 400

    username = data['username']
    password = data['password']

    # Provjera je li korisnik vec u bazi podataka
    if User.query.filter_by(username=username).first():
        return jsonify({'message': 'User already exists'}), 409

    # Hashaj lozinku pomocu generate_password_hash,
    hashed_password = generate_password_hash(password, method='pbkdf2:sha256')

    # Kreiraj novog korisnika s hashanom lozinkom te dodaj u bazu
    new_user = User(username=username, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

# Vraca token response na rutu ako su credentialsi dobri
@app.route('/login', methods=['POST'])
def login():
    auth = request.get_json()

    if not auth or not auth.get('username') or not auth.get('password'):
        return jsonify({'message': 'Could not verify'}), 400

    username = auth['username']
    password = auth['password']

    # Query za korisnika u MySQL bazi s danim usernameom
    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password, password):
        # Enkodiraj token u trajanju od 4h (privremeno dok se ne implementiraju access i refresh tokeni)
        token = jwt.encode({
            'user': username,
            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=4)
        }, app.config['SECRET_KEY'], algorithm='HS256')

        return jsonify({'token': token})

    return jsonify({'message': 'Invalid credentials'}), 401

# Logged in ruta s tokenom, vraca osnovni hello world
@app.route('/protected', methods=['GET'])
@token_required
def protected(current_user):
    return jsonify({'message': f'Hello world {current_user}'})

@token_required
@app.route('/getplaces', methods=['POST'])
def nearby_places():
    data = request.get_json()
    latitude = data.get("latitude")
    longitude = data.get("longitude")
    radius = data.get("radius", 1000)  # Default radius is 1000 meters
    place_type = data.get("type", "restaurant")  # Default search type is restaurant

    if not latitude or not longitude:
        return jsonify({"message": "Latitude and longitude are required"}), 400

    # print(f"Latitude: {latitude}, Longitude: {longitude}")

    url = "https://places.googleapis.com/v1/places:searchNearby"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
        "X-Goog-FieldMask": "places.id,places.displayName,places.location,places.rating"
    }
    payload = {
        "includedTypes": [place_type],
        "maxResultCount": 10,
        "locationRestriction": {
            "circle": {
                "center": {"latitude": latitude, "longitude": longitude},
                "radius": radius
            }
        }
    }

    # print(f"Poziv na google API:")

    response = requests.post(url, headers=headers, data=json.dumps(payload))

    # print(f"{response}")

    data = response.json()

    if response.status_code != 200 or "places" not in data:
        return jsonify({"message": "Failed to fetch places from Google Places API"}), 500

    matched_places = []

    for place in data["places"]:
        google_place_id = place.get("id")
        business = BusinessUser.query.filter_by(google_place_id=google_place_id).first()

        if business:
            matched_places.append({
                "name": business.name,
                "email": business.email,
                "phone": business.phone,
                "address": business.address,
                "parking_total": business.parking,
                "opis": business.opis,
                "rating": place.get("rating")
            })

    return jsonify(matched_places)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=8080)
