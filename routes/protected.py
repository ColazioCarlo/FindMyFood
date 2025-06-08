from flask import Blueprint, jsonify
from utils.auth_utils import token_required
from models.user import User
from models.BusinessUser import BusinessUser

protected_bp = Blueprint('protected', __name__)

@protected_bp.route("/protected", methods=["GET"])
@token_required
def protected(current_user):
    return jsonify({"message": f"Hello world {current_user.username}"})

@protected_bp.route("/whoami", methods=["GET"])
@token_required
def whoami(current_user):
    # Probaj dohvatiti podatke o (business) korisniku
    if isinstance(current_user, BusinessUser):
        response = {
            "name": current_user.name,
            "email": current_user.email,
            "phone": current_user.phone,
            "address": current_user.address,
            "parkingTotal": current_user.parkingtotal,
            "opis": current_user.opis,
            "type": "business"
        }
    elif isinstance(current_user, User):
        response = {
            "username": current_user.username,
            "balance": current_user.balance,
            "type": "user"
        }
    else:
        response = {"message": "Unknown user type"}
    return jsonify(response)
