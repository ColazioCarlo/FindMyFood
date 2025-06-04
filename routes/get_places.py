from flask import Blueprint, jsonify, request, current_app
from utils.auth_utils import token_required
import json
import requests
from config import Config
from models.user import User
from models.BusinessUser import BusinessUser

GOOGLE_MAPS_API_KEY = Config.MAPS_API_KEY  # da se kolegi ne nabije racun :D

getplaces_bp = Blueprint("getplaces", __name__)

@getplaces_bp.route("/getplaces", methods=["POST"])
@token_required
def nearby_places(*args, **kwargs):
    data = request.get_json()
    latitude = data.get("latitude")
    longitude = data.get("longitude")
    radius = data.get("radius", 1000)
    place_type = data.get("type", "restaurant")
    max_results = data.get("max_results", 10)

    if not latitude or not longitude:
        return jsonify({"message": "Latitude and longitude are required"}), 400

    # print(f"Latitude: {latitude}, Longitude: {longitude}")

    url = "https://places.googleapis.com/v1/places:searchNearby"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
        "X-Goog-FieldMask": "places.id,places.displayName,places.location,places.rating,places.photos",
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

    # print(f"Poziv na google API:")

    response = requests.post(url, headers=headers, data=json.dumps(payload))

    # print(f"{response}")

    data = response.json()
    # print(data)
    if response.status_code != 200 or "places" not in data:
        return jsonify({"message": "Failed to fetch places from Google Places API"}), 500

    matched_places = []

    for place in data["places"]:
        google_place_id = place.get("id")
        business = BusinessUser.query.filter_by(google_place_id=google_place_id).first()

        if business:
            photo_uri = None
            photos = place.get("photos", [])
            
            if photos:
                photo_name = photos[0].get("name")
                photo_width = photos[0].get("widthPx")
                photo_height = photos[0].get("heightPx")
                
                if photo_name:
                    # Build the photo URI with the given parameters
                    photos_api_url = f"https://places.googleapis.com/v1/{photo_name}/media?key={GOOGLE_MAPS_API_KEY}&maxWidthPx={photo_width}&maxHeightPx={photo_height}&skipHttpRedirect=true"

                    photo_response = requests.get(photos_api_url)
                    if photo_response.status_code == 200:
                        photo_json = photo_response.json()
                        photo_uri = photo_json.get("photoUri")
            
            matched_places.append(
                {
                    "name": business.name,
                    "email": business.email,
                    "phone": business.phone,
                    "address": business.address,
                    "parking_total": business.parkingtotal,
                    "parking_free": business.parkingfree,
                    "opis": business.opis,
                    "rating": place.get("rating"),
                    "photoUri": photo_uri
                }
            )

    return jsonify(matched_places)
