from flask import Flask, request, jsonify
import jwt
import datetime
from functools import wraps

app = Flask(__name__)
# u .env kasnije, moze biti bilo sto jer se hashira
app.config['SECRET_KEY'] = 'aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ==' 

# Simuliran database
users = {
    "test":"test123"
}

def token_required(f):
    @wraps(f) # Dekorator za dekorator (prati kontekstu flask rute)
    def decorated(*args, **kwargs):
        token = request.headers.get('Token')
        if not token:
            return jsonify({'message': 'Token was not provided'}), 401

        try:
            if 'bearer_' in token.lower():
                token = token.replace('Bearer_','').replace('bearer_','')

            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
            current_user = data['user']

        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token expired!'}), 401
        
        except (jwt.InvalidTokenError, Exception):
            return jsonify({'message': 'Token is invalid!'}), 401

        return f(current_user, *args, **kwargs)
    return decorated

# Vraca token response na rutu ako su credentialsi dobri
@app.route('/login', methods=['POST'])
def login():
    auth = request.get_json()

    if not auth or not auth.get('username') or not auth.get('password'):
        return jsonify({'message': 'Could not verify'}), 400

    username = auth['username']
    password = auth['password']

    if users.get(username) == password:
        # Enkodiraj token u trajanju od 4h (privremeno dok se ne implementiraju access i refresh tokeni)
        token = jwt.encode({
            'user': username,
            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=4)
        }, app.config['SECRET_KEY'], algorithm='HS256')

        return jsonify({'token': token})

    return jsonify({'message': 'Invalid credentials'}), 401

# Logged in ruta s tokenom, vraca osnovni hello world
@app.route('/protected', methods=['GET'])
@token_required
def protected(current_user):
    return jsonify({'message': f'Hello world {current_user}'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
