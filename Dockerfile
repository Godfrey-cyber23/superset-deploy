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

# Create a startup script that runs initialization THEN starts Superset
RUN echo "#!/bin/bash" > /app/startup.sh && \
    echo "set -e" >> /app/startup.sh && \
    echo "echo '=== Starting Superset Initialization Sequence ==='" >> /app/startup.sh && \
    echo "# Wait for database to be ready" >> /app/startup.sh && \
    echo "echo 'Waiting for database connection...'" >> /app/startup.sh && \
    echo "sleep 15" >> /app/startup.sh && \
    echo "# Initialize database" >> /app/startup.sh && \
    echo "echo 'Running database upgrade...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset db upgrade" >> /app/startup.sh && \
    echo "echo 'Database upgrade completed'" >> /app/startup.sh && \
    echo "# Create admin user (skip if already exists)" >> /app/startup.sh && \
    echo "echo 'Creating admin user...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset fab create-admin --username admin --firstname Admin --lastname User --email godfreyb998@gmail.com --password Admin@2025 || echo 'Admin user may already exist'" >> /app/startup.sh && \
    echo "echo 'Admin user setup completed'" >> /app/startup.sh && \
    echo "# Initialize Superset" >> /app/startup.sh && \
    echo "echo 'Initializing Superset...'" >> /app/startup.sh && \
    echo "/app/.venv/bin/superset init || echo 'Superset initialization completed or already done'" >> /app/startup.sh && \
    echo "echo '=== Starting Superset Server ==='" >> /app/startup.sh && \
    echo "# Start the main Superset application" >> /app/startup.sh && \
    echo "exec /app/docker/docker-bootstrap.sh server" >> /app/startup.sh && \
    chmod +x /app/startup.sh

USER superset

# Use our startup script
CMD ["/app/startup.sh"]