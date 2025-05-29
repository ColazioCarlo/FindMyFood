from extensions import db

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

