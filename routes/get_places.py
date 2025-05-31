from flask import Blueprint, jsonify, request, current_app
from utils.auth_utils import token_required
import json
import requests
from config import Config
from models.user import User
from models.BusinessUser import BusinessUser

GOOGLE_MAPS_API_KEY = Config.MAPS_API_KEY  # da se kolegi ne nabije racun :D

getplaces_bp = Blueprint("getplaces", __name__)


# Query Google Places API to get the Place ID for the given address
def get_place_id(address):
    url = "https://places.googleapis.com/v1/places:searchText"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
        "X-Goog-FieldMask": "places.id",
    }
    payload = {"textQuery": address}

    response = requests.post(url, headers=headers, json=payload)
    data = response.json()

    if response.status_code == 200 and "places" in data and data["places"]:
        return data["places"][0]["id"]
    return None


@getplaces_bp.route("/getplaces", methods=["GET"])
@token_required
def nearby_places(*args, **kwargs):
    data = request.get_json()
    latitude = data.get("latitude")
    longitude = data.get("longitude")
    radius = data.get("radius", 1000)  # Default radius is 1000 meters
    place_type = data.get("type", "restaurant")  # Default search type is restaurant

    if not latitude or not longitude:
        return jsonify({"message": "Latitude and longitude are required"}), 400
    print(f"Maps key: {GOOGLE_MAPS_API_KEY}")
    print(f"Latitude: {latitude}, Longitude: {longitude}")

    url = "https://places.googleapis.com/v1/places:searchNearby"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
        "X-Goog-FieldMask": "places.id,places.displayName,places.location,places.rating",
    }
    payload = {
        "includedTypes": [place_type],
        "maxResultCount": 10,
        "locationRestriction": {
            "circle": {
                "center": {"latitude": latitude, "longitude": longitude},
                "radius": radius,
            }
        },
    }

    print(f"Poziv na google API:")

    response = requests.post(url, headers=headers, data=json.dumps(payload))

    print(f"{response}")

    data = response.json()
    print(data)
    # if response.status_code != 200 or "places" not in data:
    #    return jsonify({"message": "Failed to fetch places from Google Places API"}), 500

    matched_places = []

    for place in data["places"]:
        google_place_id = place.get("id")
        business = BusinessUser.query.filter_by(google_place_id=google_place_id).first()

        if business:
            matched_places.append(
                {
                    "name": business.name,
                    "email": business.email,
                    "phone": business.phone,
                    "address": business.address,
                    "parking_total": business.parking,
                    "opis": business.opis,
                    "rating": place.get("rating"),
                }
            )

    return jsonify(matched_places)
