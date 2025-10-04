import os

# Use Render's provided PORT
PORT = int(os.environ.get("PORT", 8088))

# Database configuration - FORCE PyMySQL dialect
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI", 
    "mysql+pymysql://admin:FinalYearProject*2025@exam-system-db.cmvs2sqwmdz5.us-east-1.rds.amazonaws.com:3306/exam_system_db"
)

# Force SQLAlchemy to use PyMySQL dialect
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_recycle': 3600,
    'pool_pre_ping': True,
    'pool_size': 10,
    'max_overflow': 20,
}

# Secret key
SECRET_KEY = os.environ.get(
    "SUPERSET_SECRET_KEY", 
    "nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"
)

# CORS for your frontend
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': [
        'https://exam-system-frontend-eight.vercel.app',
        'http://localhost:3000',
        'http://localhost:5173'
    ]
}

# Public role permissions
PUBLIC_ROLE_LIKE = "Gamma"

# Additional production settings
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = 3600

# Feature flags
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
    "ALERT_REPORTS": True,
}

# Cache configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',
    'CACHE_DEFAULT_TIMEOUT': 300
}