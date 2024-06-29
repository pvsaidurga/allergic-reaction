import logging
from tokenize import String
from flask import Flask, json, request, jsonify
from getIngrediateDetails import extract_health_records
from werkzeug.utils import secure_filename
import os
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from upload_Files_to_Blob import upload_image, upload_profile
from summerizeTheDetails import summerize

app = Flask(__name__)

# Configuration
app.config['UPLOAD_FOLDER_HEALTH_REPORTS'] = 'uploads/uploadHealthReports'
app.config['UPLOAD_FOLDER_PRODUCT_IMAGES'] = 'uploads/uploadProductImages'
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:root@localhost:5432/User_Heath_Record'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    mobile = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

    def __init__(self, username, email, mobile, password):
        self.username = username
        self.email = email
        self.mobile = mobile
        self.password = generate_password_hash(password, method='pbkdf2:sha256')

# Define UserHealthRecord model
class UserHealthRecords(db.Model):
    # id = db.Column(db.Integer, primary_key=True)
    # user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    user_id =db.Column(db.Integer,primary_key=True)
    age = db.Column(db.String(10))
    height = db.Column(db.String(10))
    weight = db.Column(db.String(10))
    blood_group = db.Column(db.String(10))
    hemoglobin = db.Column(db.String(10))
    rbc_count = db.Column(db.String(10))
    wbc_count = db.Column(db.String(10))
    platelet_count = db.Column(db.String(10))
    # user = db.relationship('User', backref=db.backref('health_records', lazy=True))

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    logging.debug(f'Received data: {data}')

    username = data.get('username')
    email = data.get('email')
    mobile = data.get('mobile')
    password = data.get('password')
    
    if not all([username, email, mobile, password]):
        return jsonify({'message': 'All fields are required'}), 400

    new_user = User(username, email, mobile, password)
    
    try:
        db.session.add(new_user)
        db.session.commit()
        logging.debug('User registered successfully')
        return jsonify({'message': 'User registered successfully'}), 201
    except exc.IntegrityError as e:
        db.session.rollback()
        error_message = str(e.orig)
        logging.error(f'IntegrityError: {error_message}')
        if 'duplicate key value violates unique constraint' in error_message:
            if 'username' in error_message:
                return jsonify({'message': 'Username already exists'}), 409
            elif 'email' in error_message:
                return jsonify({'message': 'Email already exists'}), 409
        return jsonify({'message': 'An error occurred'}), 500
    except Exception as e:
        db.session.rollback()
        logging.error(f'Exception: {str(e)}')
        return jsonify({'message': 'An unexpected error occurred'}), 500

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password=data.get('password')
    user = User.query.filter_by(username=username).first()

    if user and check_password_hash(user.password, password):   
        return jsonify({'id': user.id, 'username': user.username, 'email': user.email, 'mobile': user.mobile}), 200
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

@app.route('/uploadhealthrecord', methods=['POST'])
def upload_health_record():
    try:
        user_id = request.form.get('user_id')
        file = request.files['file']
        if file:
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER_HEALTH_REPORTS'], filename)
            file.save(file_path)
            user = User.query.get(user_id)
            if not user:
                return jsonify({'message': 'User not found'}), 404
            user_id = user.id
            extracted_health_profile_report=upload_profile(file_path)          
            content=extract_health_records(extracted_health_profile_report.data)                           
            values=content.split(",")
            # values=['23 Years', ' 5.6', ' 60', ' null', ' 12.5', ' 5.2', ' null', ' 540000']
            user_health_record = UserHealthRecords.query.filter_by(user_id=user_id).first()
            if user_health_record:
                user_health_record.user_id = user_id
                user_health_record.age = values[0]
                user_health_record.height = values[1]
                user_health_record.weight = values[2]
                user_health_record.blood_group = values[3]
                user_health_record.hemoglobin = values[4]
                user_health_record.rbc_count = values[5]
                user_health_record.wbc_count = values[6]
                user_health_record.platelet_count = values[7]
                db.session.commit()
                return jsonify({'message': 'User health record updated'}), 200
            else:
                health_record = UserHealthRecords(
                user_id=user_id,
                age=values[0],
                height=values[1],
                weight=values[2],
                blood_group=values[3],
                hemoglobin=values[4],
                rbc_count=values[5],
                wbc_count=values[6],
                platelet_count=values[7]
                )
                db.session.add(health_record)
                db.session.commit()
                return jsonify({'message': 'User health record created'}), 200
        else:
            return jsonify({'message': 'No file received'}), 400

    except Exception as e:
        logging.error(f'Error uploading health report: {e}')
        return jsonify({'message': 'Failed to upload health report'}), 500

@app.route('/uploadProduct', methods=['POST'])
def upload_product():
    try:
        file = request.files['file']
        user_id = request.form.get('user_id')
        selected_groups = request.form.get('selectedGroups')
        selected_foodOrBodyCare_items = request.form.get('selectedFoodOrBodyCareItems')  # Extract selected food items
        genrep=''
        if file:
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER_PRODUCT_IMAGES'], filename)
            file.save(file_path)
            user = User.query.get(user_id)
            if not user:
                return jsonify({'message': 'User not found'}), 404
            user_id = user.id
            extracted_ingredients = upload_image(file_path)
            if selected_groups:
                selected_groups_list = selected_groups.split(',')
                fetched_health_record = fetch_health_details(user_id)
                genrep = generatereport(extracted_ingredients, selected_groups_list, fetched_health_record,selected_foodOrBodyCare_items)
                print(genrep)
                return jsonify({'genrep':genrep})
            return jsonify({'message': 'file received', 'genrep': genrep}), 200            
        else:
            return jsonify({'message': 'No file received'}), 400

    except Exception as e:
        logging.error(f'Error uploading product image: {e}')
        return jsonify({'message': 'Failed to upload product image'}), 500


@app.route('/fetchhealthdetails/<int:user_id>', methods=['GET'])
def fetch_health_details(user_id):
    try:
        records = UserHealthRecords.query.filter_by(user_id=user_id).all()
        result = [
            {
                'user_id': record.user_id,
                'age': record.age,
                'height': record.height,
                'weight': record.weight,
                'blood_group': record.blood_group,
                'hemoglobin': record.hemoglobin,
                'rbc_count': record.rbc_count,
                'wbc_count': record.wbc_count,
                'platelet_count': record.platelet_count
            }
            for record in records
        ]
        return jsonify(result), 200
    except Exception as e:
        logging.error(f'Error in fetching health record: {e}')
        return jsonify({'message': 'Failed to fetch health records'}), 500
    
@app.route('/get_user/<int:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = User.query.filter_by(id=user_id).first()
        if user:
            return jsonify({
                'username': user.username,
                'email': user.email,
                'mobile': user.mobile
            }), 200
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        logging.error(f'Error fetching user details: {e}')
        return jsonify({'error': 'Failed to fetch user details'}), 500

@app.route('/update_user', methods=['POST'])
def update_user():
    try:
        data = request.json
        user_id = data.get('user_id')
        username = data.get('username')
        email = data.get('email')
        mobile = data.get('mobile')

        user = User.query.filter_by(id=user_id).first()
        if not user:
            return jsonify({'error': 'User not found'}), 404

        user.username = username
        user.email = email
        user.mobile = mobile

        db.session.commit()
        return jsonify({'message': 'User details updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        logging.error(f'Error updating user details: {e}')
        return jsonify({'error': 'Failed to update user details'}), 500

@app.route('/change_password', methods=['POST'])
def change_password():
    try:
        data = request.json
        user_id = data.get('user_id')
        old_password = data.get('old_password')
        new_password = data.get('new_password')

        user = User.query.filter_by(id=user_id).first()
        if not user:
            return jsonify({'error': 'User not found'}), 404

        if not check_password_hash(user.password, old_password):
            return jsonify({'error': 'Old password is incorrect'}), 400

        user.password = generate_password_hash(new_password, method='pbkdf2:sha256')
        db.session.commit()
        return jsonify({'message': 'Password changed successfully'}), 200
    except Exception as e:
        db.session.rollback()
        logging.error(f'Error changing password: {e}')
        return jsonify({'error': 'Failed to change password'}), 500

@app.route('/get_user_health_details/<int:user_id>', methods=['GET'])
def get_userhealthdetails(user_id):
    try:
        user = UserHealthRecords.query.filter_by(user_id=user_id).first()
        if user:
            return jsonify({
                'age': user.age,
                'height': user.height,
                'weight': user.weight,
                'blood_group': user.blood_group
            }), 200
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        logging.error(f'Error fetching user health details: {e}')
        return jsonify({'error': 'Failed to fetch user health details'}), 500

@app.route('/update_user_health_details', methods=['POST'])
def update_userhealthdetails():
    try:
        data = request.json
        user_id = data.get('user_id')
        age = data.get('age')
        height = data.get('height')
        weight = data.get('weight')
        blood_group = data.get('blood_group')

        user = UserHealthRecords.query.filter_by(user_id=user_id).first()
        if not user:
            return jsonify({'error': 'User not found'}), 404

        
        user.age = age
        user.height = height
        user.weight = weight
        user.blood_group = blood_group

        db.session.commit()
        return jsonify({'message': 'User Health details updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        logging.error(f'Error updating user health details: {e}')
        return jsonify({'error': 'Failed to update user health details'}), 500

def generatereport(selected_groups_list,extracted_ingredients,fetchedhealthrecord,selected_foodOrBodyCare_items):
    try:
        report=summerize(selected_groups_list,extracted_ingredients,fetchedhealthrecord,selected_foodOrBodyCare_items)
        return report
    except Exception as e:
        logging.error(f'Error in generating report: {e}')
        return jsonify({'message': 'Failed to Generate reports'}), 500
    
def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)
