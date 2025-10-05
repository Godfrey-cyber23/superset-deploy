import os

# Server configuration
PORT = int(os.environ.get("PORT", 8088))

# Database Configuration - The URI is passed from the environment variable
SQLALCHEMY_DATABASE_URI = os.environ.get("SQLALCHEMY_DATABASE_URI")

# Secret key
SECRET_KEY = os.environ.get("SUPERSET_SECRET_KEY")

# Security settings
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = 3600

# CORS configuration
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

# Feature flags
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
    "ALERT_REPORTS": True,
}

# Database connection pool settings
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_recycle': 3600,
    'pool_pre_ping': True,
    'pool_size': 5,
    'max_overflow': 10,
    'pool_timeout': 30,
}

# Cache configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',
    'CACHE_DEFAULT_TIMEOUT': 300
}

# Enable proxy fix for Render's load balancer
ENABLE_PROXY_FIX = True

# Security headers
SESSION_COOKIE_SECURE = False  # Set to True if using HTTPS
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = 'Lax'