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
    # Use system pip to install directly into the virtual environment's site-packages
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported in virtual environment')"

# Create initialization script to ensure admin user is created with correct password
RUN echo "#!/bin/bash" > /app/init_admin.sh && \
    echo "# Wait for Superset to be ready" >> /app/init_admin.sh && \
    echo "sleep 20" >> /app/init_admin.sh && \
    echo "# Ensure admin user is created with correct password" >> /app/init_admin.sh && \
    echo "/app/.venv/bin/superset fab reset-password --username admin --password Admin@2025 2>/dev/null || echo 'Password reset completed or user does not exist'" >> /app/init_admin.sh && \
    echo "echo 'Admin password initialization completed'" >> /app/init_admin.sh && \
    chmod +x /app/init_admin.sh

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.