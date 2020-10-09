import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = True
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = 'this-really-needs-to-be-changed'
    DATABASE_URL='postgresql://postgres:postgres@postgres:5432/demo_db'
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
