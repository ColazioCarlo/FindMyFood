import os
from dotenv import load_dotenv

_ = load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://FindMyFood:findmyfood@localhost/FindMyFood"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    REFRESH_SECRET_KEY = os.getenv('REFRESH_SECRET_KEY') 
