import os

# --- Secret Key ---
# Generate a new, long, random string for this.
# You can use: openssl rand -base64 42
SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'a_very_secret_and_long_random_string_change_me')

# --- Database Configuration ---
# This is the most critical part. We construct the SQLAlchemy connection string
# from your AWS RDS details.
# IMPORTANT: The password must be URL-encoded if it contains special characters.
from urllib.parse import quote_plus

DB_USER = os.environ.get('DB_USER', 'admin')
DB_PASSWORD = quote_plus(os.environ.get('DB_PASSWORD', 'FinalYearProject*2025'))
DB_HOST = os.environ.get('DB_HOST', 'exam-system-db.cmvs2sqwmdz5.us-east-1.rds.amazonaws.com')
DB_PORT = os.environ.get('DB_PORT', '3306')
DB_NAME = os.environ.get('DB_NAME', 'exam_system_db')

# The SQLAlchemy connection string for your MySQL database
SQLALCHEMY_DATABASE_URI = f'mysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'

# --- Performance and Caching (Recommended) ---
# Superset can use Redis for caching, which significantly improves performance.
# You can add a Redis instance on Render for this.
REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost') # Use Render's Redis host
REDIS_PORT = os.environ.get('REDIS_PORT', '6379')
REDIS_URL = f'redis://{REDIS_HOST}:{REDIS_PORT}/1'

# Cache for metadata
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_REDIS_URL': REDIS_URL,
    'CACHE_DEFAULT_TIMEOUT': 300
}

# Cache for data queries
DATA_CACHE_CONFIG = CACHE_CONFIG

# --- Async Query (Celery) ---
# For long-running queries, use Celery with Redis as a broker.
# This requires a separate "worker" service on Render, which is an advanced setup.
# For now, we'll leave it disabled, but it's good to know about.
CELERY_BROKER_URL = REDIS_URL
RESULTS_BACKEND = REDIS_URL
ENABLE_ASYNC_DRUID_QUERY_EXPORT = False # Keep false unless you set up a worker

# --- Other Settings ---
SQLALCHEMY_TRACK_MODIFICATIONS = False
ENABLE_RBAC = True
SHOW_STACKTRACE = True

# --- Email Alerts (Optional) ---
# You can configure this to use your SMTP details for sending reports/alerts.
# EMAIL_REPORTS_SUBJECT_PREFIX = '[Superset] '
# SMTP_HOST = os.environ.get('SMTP_HOST')
# SMTP_PORT = int(os.environ.get('SMTP_PORT', 587))
# SMTP_USER = os.environ.get('SMTP_USER')
# SMTP_PASSWORD = os.environ.get('SMTP_PASSWORD')
# SMTP_MAIL_FROM = os.environ.get('EMAIL_FROM')