from flask import Blueprint, jsonify, request, current_app
from utils.auth_utils import token_required
import json
import requests
from models.user import User
from models.BusinessUser import BusinessUser
from extensions import db

parking_bp = Blueprint("parking", __name__)


@parking_bp.route("/reserveparking/<int:business_user_id>", methods=["POST"])
@token_required
def reserve_parking(business_user_id):
    # Dohvati business user id iz baze
    business_user = BusinessUser.query.get(business_user_id)

    if not business_user:
        return jsonify({"message": "BusinessUser not found"}), 404

    if business_user.parkingfree <= 0:
        return jsonify({"message": "No free parking spots available"}), 400

    business_user.parkingfree -= 1

    try:
        # Commit u bazu
        db.session.commit()
        return jsonify(
            {
                "message": "Parking spot reserved successfully",
                "business_user_id": business_user.id,
                "parking_free_remaining": business_user.parkingfree,
            }
        ), 200
    except Exception as e:
        db.session.rollback()  # Rollback u slucaju nehandleanog errora
        current_app.logger.error(f"Error reserving parking: {e}")
        return jsonify({"message": "Failed to reserve parking", "error": str(e)}), 500


@parking_bp.route("/freeparking/<int:business_user_id>", methods=["POST"])
@token_required
def free_parking(business_user_id):
    # Dohvati business user id iz baze
    business_user = BusinessUser.query.get(business_user_id)

    if not business_user:
        return jsonify({"message": "BusinessUser not found"}), 404

    business_user.parkingfree += 1

    try:
        # Commit u bazu
        db.session.commit()
        return jsonify(
            {
                "message": "Parking spot freed successfully",
                "business_user_id": business_user.id,
                "parking_free_remaining": business_user.parkingfree,
            }
        ), 200
    except Exception as e:
        db.session.rollback()  # Rollback u slucaju nehandleanog errora
        current_app.logger.error(f"Error freeing parking: {e}")
        return jsonify({"message": "Failed to free parking", "error": str(e)}), 500
