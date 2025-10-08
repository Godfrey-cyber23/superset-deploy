import os
from urllib.parse import quote_plus

# Secret Key
SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'zgNXQSWHhdNcLpJ0kNGwv7bza9V2l+aEfT7n+vNArrEa/pH+0VUliBgF')

# Database Configuration
DB_USER = os.environ.get('DB_USER', 'admin')
DB_PASSWORD = quote_plus(os.environ.get('DB_PASSWORD', 'FinalYearProject*2025'))
DB_HOST = os.environ.get('DB_HOST', 'exam-system-db.cmvs2sqwmdz5.us-east-1.rds.amazonaws.com')
DB_PORT = os.environ.get('DB_PORT', '3306')
DB_NAME = os.environ.get('DB_NAME', 'exam_system_db')

# Use PyMySQL connection string explicitly
SQLALCHEMY_DATABASE_URI = f'mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'

# Other Settings
SQLALCHEMY_TRACK_MODIFICATIONS = False
ENABLE_RBAC = True
SHOW_STACKTRACE = True
ENABLE_ASYNC_DRUID_QUERY_EXPORT = False

# =============================================================================
# EMBEDDING AND IFRAME CONFIGURATION
# =============================================================================

# Enable dashboard embedding
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True,
    "DASHBOARD_EMBEDDING": True,
    "ALLOW_IFRAME_EMBEDDING": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
}

# Disable X-Frame-Options to allow embedding from different origins
HTTP_HEADERS = {}
X_FRAME_OPTIONS = "ALLOWALL"

# CORS configuration to allow cross-origin requests
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ['*']  # For production, replace with your specific domains
}

# Public role like Gamma for embedded dashboards
PUBLIC_ROLE_LIKE = "Gamma"

# Additional security settings for embedding
WTF_CSRF_ENABLED = False  # Disable CSRF for embedded dashboards
TALISMAN_ENABLED = False  # Disable Talisman security headers for embedding

# Dashboard embedding specific settings
DASHBOARD_EMBEDDING = True
EMBEDDED_SUPERSET = True

# Session configuration for embedded use
SESSION_COOKIE_SAMESITE = None
SESSION_COOKIE_SECURE = False

# =============================================================================
# RENDER.COM SPECIFIC CONFIGURATION
# =============================================================================

# Render.com specific settings
MAPBOX_API_KEY = os.environ.get('MAPBOX_API_KEY', '')
BABEL_DEFAULT_FOLDER = 'babel'
LANGUAGES = {
    'en': {'flag': 'us', 'name': 'English'},
    'es': {'flag': 'es', 'name': 'Spanish'},
    'it': {'flag': 'it', 'name': 'Italian'},
    'fr': {'flag': 'fr', 'name': 'French'},
    'zh': {'flag': 'cn', 'name': 'Chinese'},
}

# Cache configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',
    'CACHE_DEFAULT_TIMEOUT': 300
}

# File upload configuration
UPLOAD_FOLDER = '/tmp/superset_uploads/'
MAX_UPLOAD_SIZE = 50 * 1024 * 1024  # 50MB

# Celery configuration (if using async queries)
class CeleryConfig:
    BROKER_URL = 'redis://localhost:6379/0'
    CELERY_IMPORTS = ('superset.sql_lab',)
    CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
    CELERY_ANNOTATIONS = {'tasks.add': {'rate_limit': '10/s'}}

CELERY_CONFIG = CeleryConfig

# =============================================================================
# DASHBOARD EMBEDDING URL PATTERNS
# =============================================================================

# Optional: Define specific domains that can embed your dashboards
# For now, we're allowing all domains with '*'
# In production, you might want to restrict this:
# EXAMPLE_RESTRICTED_ORIGINS = [
#     "https://yourapp.com",
#     "https://admin.yourapp.com",
# ]

print("Superset configuration loaded with embedding enabled")