import os

# Use Render's provided PORT
PORT = int(os.environ.get("PORT", 8088))

# Use SQLite for Superset metadata (built-in, no external dependencies)
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI", 
    "sqlite:////app/superset_home/superset.db"
)

# Secret key
SECRET_KEY = os.environ.get(
    "SUPERSET_SECRET_KEY", 
    "nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"
)

# CORS for your frontend
ENABLE_CORS = False
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