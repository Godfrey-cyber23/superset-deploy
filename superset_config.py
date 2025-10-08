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