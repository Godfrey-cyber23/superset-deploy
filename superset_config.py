import os

# Use Render's provided PORT
PORT = int(os.environ.get("PORT", 8088))

# AWS MySQL Database Configuration
# It is safer to get the entire URI from the environment variable set in render.yml
SQLALCHEMY_DATABASE_URI = os.environ.get("SQLALCHEMY_DATABASE_URI")
# If you must set a fallback, use the pymysql driver:
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI",
    "mysql+pymysql://admin:FinalYearProject*2025@exam-system-db.cmvs2sqwmdz5.us-east-1.rds.amazonaws.com:3306/exam_system_db"
)

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

# Database connection pool settings (important for production)
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_recycle': 3600,  # Recycle connections before AWS RDS timeout
    'pool_pre_ping': True, # Verify connection is alive before using
    'pool_size': 10,
    'max_overflow': 20,
}

# Enable proxy fix for handling headers correctly behind Render's load balancer
ENABLE_PROXY_FIX = True