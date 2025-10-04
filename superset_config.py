# superset_config.py

import os
import logging

# Set up logging to print to the console so we can see it in the Render logs
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Use Render's provided PORT
PORT = int(os.environ.get("PORT", 8088))

# --- Database Configuration ---
# This is the most important part. We will debug it.
db_uri_from_env = os.environ.get("SQLALCHEMY_DATABASE_URI")

# Log the raw value from the environment variable
logger.info(f"DEBUG: Raw SQLALCHEMY_DATABASE_URI from environment is: '{db_uri_from_env}'")

# Set the final URI. If the env var is not set, this will be None and cause the error.
if db_uri_from_env:
    SQLALCHEMY_DATABASE_URI = db_uri_from_env
else:
    # This block should NOT be reached on Render if your render.yaml is correct.
    # If it is, it means the environment variable is not being passed to the container.
    logger.error("CRITICAL: SQLALCHEMY_DATABASE_URI environment variable is NOT SET! Application will fail.")
    # We set it to None explicitly to show the error.
    SQLALCHEMY_DATABASE_URI = None

# Log the final value being used by Superset
logger.info(f"DEBUG: Final SQLALCHEMY_DATABASE_URI is: '{SQLALCHEMY_DATABASE_URI}'")

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

# Database connection pool settings
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_recycle': 3600,
    'pool_pre_ping': True,
    'pool_size': 10,
    'max_overflow': 20,
}

# Enable proxy fix for Render's load balancer
ENABLE_PROXY_FIX = True