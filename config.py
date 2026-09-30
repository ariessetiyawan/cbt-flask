import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'cbt-secret-key-ganti-di-production')
    DB_HOST = 'localhost'
    DB_USER = 'root'
    DB_PASSWORD = ''
    DB_NAME = 'cbt_app'