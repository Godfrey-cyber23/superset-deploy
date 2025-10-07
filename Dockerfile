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

# Create initialization script to set up database and admin user
RUN echo "#!/bin/bash" > /app/init_superset.sh && \
    echo "# Wait for database to be ready" >> /app/init_superset.sh && \
    echo "sleep 10" >> /app/init_superset.sh && \
    echo "# Initialize database" >> /app/init_superset.sh && \
    echo "/app/.venv/bin/superset db upgrade" >> /app/init_superset.sh && \
    echo "# Create admin user" >> /app/init_superset.sh && \
    echo "/app/.venv/bin/superset fab create-admin --username admin --firstname Admin --lastname User --email godfreyb998@gmail.com --password Admin@2025" >> /app/init_superset.sh && \
    echo "# Initialize Superset" >> /app/init_superset.sh && \
    echo "/app/.venv/bin/superset init" >> /app/init_superset.sh && \
    echo "echo 'Superset initialization completed'" >> /app/init_superset.sh && \
    chmod +x /app/init_superset.sh

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.