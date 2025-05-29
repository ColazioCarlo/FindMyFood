from extensions import db

class RefreshToken(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(255), unique=True, nullable=False)

    # Strani ključ koji povezuje refresh token s korisnikom.
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # Datum isteka refresh tokena.
    expiry_date = db.Column(db.DateTime, nullable=False)
    
    def __repr__(self):
        return f"<RefreshToken {self.token}>"
