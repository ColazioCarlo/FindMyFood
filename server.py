from flask import Flask, jsonify
from routes.auth import auth_bp
from routes.protected import protected_bp
from routes.get_places import getplaces_bp
from routes.parking import parking_bp
from extensions import db
from constants import ACCESS_TOKEN_LIFETIME, REFRESH_TOKEN_LIFETIME
from flask_sqlalchemy import SQLAlchemy
from config import Config
import datetime


if __name__ == "__main__":
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    app.register_blueprint(auth_bp, url_prefix="/")
    app.register_blueprint(protected_bp, url_prefix="/")
    app.register_blueprint(getplaces_bp, url_prefix="/")
    app.register_blueprint(parking_bp, url_prefix="/")

    with app.app_context():
        db.create_all()

    app.run(debug=True, host="0.0.0.0", port=8080)
