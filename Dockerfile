# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install PyMySQL directly into the virtual environment using system pip
USER root
RUN echo "=== Installing PyMySQL directly into virtual environment ===" && \
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported in virtual environment')"

# Create a startup script that handles migration conflicts
RUN echo "#!/bin/bash" > /app/startup.sh && \
    echo "set -e" >> /app/startup.sh && \
    echo "echo '=== Starting Superset Initialization Sequence ==='" >> /app/startup.sh && \
    echo "# Wait for database to be ready" >> /app/startup.sh && \
    echo "echo 'Waiting for database connection...'" >> /app/startup.sh && \
    echo "sleep 15" >> /app/startup.sh && \
    echo "# Fix migration conflicts by resetting alembic version" >> /app/startup.sh && \
    echo "echo 'Checking for migration conflicts...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/python -c \"\"\"" >> /app/startup.sh && \
    echo "from sqlalchemy import create_engine, text" >> /app/startup.sh && \
    echo "import os" >> /app/startup.sh && \
    echo "db_url = os.environ.get('SQLALCHEMY_DATABASE_URI') or f'mysql+pymysql://{os.environ.get(\\\"DB_USER\\\", \\\"admin\\\")}:{os.environ.get(\\\"DB_PASSWORD\\\", \\\"FinalYearProject*2025\\\")}@{os.environ.get(\\\"DB_HOST\\\")}:{os.environ.get(\\\"DB_PORT\\\", \\\"3306\\\")}/{os.environ.get(\\\"DB_NAME\\\", \\\"exam_system_db\\\")}'" >> /app/startup.sh && \
    echo "engine = create_engine(db_url)" >> /app/startup.sh && \
    echo "try:" >> /app/startup.sh && \
    echo "    with engine.connect() as conn:" >> /app/startup.sh && \
    echo "        result = conn.execute(text(\\\"SELECT version_num FROM alembic_version\\\"))" >> /app/startup.sh && \
    echo "        current_version = result.scalar()" >> /app/startup.sh && \
    echo "        print(f'Current migration version: {current_version}')" >> /app/startup.sh && \
    echo "        # If there's a migration conflict, reset to latest" >> /app/startup.sh && \
    echo "        conn.execute(text(\\\"DELETE FROM alembic_version\\\"))" >> /app/startup.sh && \
    echo "        conn.execute(text(\\\"INSERT INTO alembic_version (version_num) VALUES ('1226819ee0e3')\\\"))" >> /app/startup.sh && \
    echo "        print('Migration version reset to latest')" >> /app/startup.sh && \
    echo "        conn.commit()" >> /app/startup.sh && \
    echo "except Exception as e:" >> /app/startup.sh && \
    echo "    print(f'No migration conflicts or table does not exist: {e}')" >> /app/startup.sh && \
    echo "\"\"\"" >> /app/startup.sh && \
    echo "# Initialize database" >> /app/startup.sh && \
    echo "echo 'Running database upgrade...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset db upgrade" >> /app/startup.sh && \
    echo "echo 'Database upgrade completed'" >> /app/startup.sh && \
    echo "# Create admin user" >> /app/startup.sh && \
    echo "echo 'Creating admin user...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset fab create-admin --username admin --firstname Admin --lastname User --email godfreyb998@gmail.com --password Admin@2025" >> /app/startup.sh && \
    echo "echo 'Admin user setup completed'" >> /app/startup.sh && \
    echo "# Initialize Superset" >> /app/startup.sh && \
    echo "echo 'Initializing Superset...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset init" >> /app/startup.sh && \
    echo "echo '=== Starting Superset Server ==='" >> /app/startup.sh && \
    echo "# Start the main Superset application" >> /app/startup.sh && \
    echo "exec /app/docker/docker-bootstrap.sh server" >> /app/startup.sh && \
    chmod +x /app/startup.sh

USER superset

# Use our startup script
CMD ["/app/startup.sh"]