from flask import Blueprint, request, jsonify, send_file
from utils.auth_utils import token_required
from models.user import User
import io
import json
import qrcode
from extensions import db

qr_bp = Blueprint('qr', __name__)

@qr_bp.route('/qr_generate', methods=['POST'])
@token_required
def qr_payment(current_user):
    data = request.get_json()
    amount = data.get('amount')
    if amount is None:
        return jsonify({'message': 'Amount is required'}), 400
    #Payload s payer_id i amount
    payment_info = {
        'payer_id': current_user.id,
        'amount': amount
    }
    payment_str = json.dumps(payment_info)
    # Generira QR kod od json stringa te vrati kao sliku
    qr = qrcode.QRCode(version=1, box_size=10, border=4)
    qr.add_data(payment_str)
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white').convert('RGB')
    buffer = io.BytesIO()
    img.save(buffer, 'PNG')
    buffer.seek(0)
    return send_file(buffer, mimetype='image/png')

@qr_bp.route('/qr_pay', methods=['POST'])
@token_required
def qr_pay(current_user):
     data = request.get_json()
     payer_id = data.get('payer_id')
     amount = data.get('amount')
     #Validacija payloada (payer_id te amount) pozeljno dekodiranih iz qr koda
     if payer_id is None or amount is None:
         return jsonify({'message': 'Invalid payment data'}), 400
               
     try:
         amount = float(amount)
     except (ValueError, TypeError):
         return jsonify({'message': 'Amount must be a valid number'}), 400

     if amount <= 0:
         return jsonify({'message': 'Amount must be greater than zero'}), 400
         
     payer = User.query.get(payer_id)
     if payer is None:
        return jsonify({'message': 'Payer not found'}), 404
    #Provjera ima li korisnik dovoljno za platiti, ako da smanji mu balance za amount
     if current_user.balance < amount:
         return jsonify({'message': 'Insufficient balance'}), 400
     current_user.balance -= amount
     db.session.commit()
     return jsonify({'message': 'Payment successful', 'balance': current_user.balance}), 200