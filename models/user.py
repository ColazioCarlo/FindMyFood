from extensions import db


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

    balance = db.Column(db.Float, nullable=False, default=0.0)

    def __repr__(self) -> str:
        return f'<User {self.username}' 


