from sqlalchemy import create_engine

class Config(object):
    SECRET_KEY="ClaveSecreta"
    SESSION_COCKIE_SECURE=False

class DevelopmentConfig(Config):
    DEBUG=True
    SQLALCHEMY_DATABASE_URI="mysql+pymysql://root:2704@127.0.0.1/examePizzas" 
    SQLALCHEMY_TRACK_MODIFICATIONS=False