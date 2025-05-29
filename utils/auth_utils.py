from functools import wraps
import jwt
import datetime
from flask import request, jsonify, current_app # Import current_app for app.config access

from constants import ACCESS_TOKEN_LIFETIME, REFRESH_TOKEN_LIFETIME
from extensions import db
from models.user import User
from models.refresh_token import RefreshToken

def generate_access_token(user):
    payload = {
        "user_id": user.id,
        "exp": datetime.datetime.now(datetime.timezone.utc) + ACCESS_TOKEN_LIFETIME,
    }
    return jwt.encode(payload, current_app.config["SECRET_KEY"], algorithm="HS256")

def generate_refresh_token(user):
    payload = {
        "user_id": user.id,
        "exp": datetime.datetime.now(datetime.timezone.utc) + REFRESH_TOKEN_LIFETIME,
    }

    refresh_token = jwt.encode(
        payload, current_app.config["REFRESH_SECRET_KEY"], algorithm="HS256"
    )

    if isinstance(refresh_token, bytes):
        refresh_token = refresh_token.decode('utf-8')

    db_token = RefreshToken(
        token=refresh_token, user_id=user.id, expiry_date=payload["exp"]
    )

    db.session.add(db_token)
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
            data = jwt.decode(token, current_app.config["SECRET_KEY"], algorithms=["HS256"])
            current_user = User.query.get(data["user_id"])
            if current_user is None:
                return jsonify({"message": "Invalid token"}), 401
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Access token expired!"}), 401
        except (jwt.InvalidTokenError, Exception) as e: # Catch generic Exception for other errors
            return jsonify({"message": f"Invalid access token! {e}"}), 401

        return f(current_user, *args, **kwargs)
    return decorated
