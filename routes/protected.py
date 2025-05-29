from flask import Blueprint, jsonify
from utils.auth_utils import token_required

protected_bp = Blueprint('protected', __name__)

@protected_bp.route("/protected", methods=["GET"])
@token_required
def protected(current_user):
    return jsonify({"message": f"Hello world {current_user.username}"})
