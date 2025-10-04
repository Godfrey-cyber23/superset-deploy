import os

# Use Render's provided PORT
PORT = int(os.environ.get("PORT", 8088))

# --- Database Configuration ---
SQLALCHEMY_DATABASE_URI = os.environ.get("SQLALCHEMY_DATABASE_URI")

# Secret key - ensure this is properly generated
SECRET_KEY = os.environ.get(
    "SUPERSET_SECRET_KEY", 
    "nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"
)

# --- Database Connection Pool Optimization ---
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_size': 5,                    # Default and typically sufficient
    'max_overflow': 10,                # Default overflow capacity
    'pool_recycle': 1800,              # Recycle connections every 30 minutes
    'pool_pre_ping': True,             # Verify connection health before use
    'pool_timeout': 30,                # Connection timeout in seconds
}

# --- Production Security & Performance ---
# Enable proxy fix for Render's load balancer
ENABLE_PROXY_FIX = True

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

# Security settings
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = 3600

# Feature flags
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
    "ALERT_REPORTS": True,
}

# Cache configuration - consider Redis for production
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',  # Upgrade to RedisCache for production
    'CACHE_DEFAULT_TIMEOUT': 300
}

# Optional: For additional database connections
# PREVENT_UNSAFE_DB_CONNECTIONS = False  # Set to True in production