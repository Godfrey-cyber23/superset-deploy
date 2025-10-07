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

# Create a startup script that runs initialization then starts Superset
RUN echo "#!/bin/bash" > /app/startup.sh && \
    echo "# Run initialization in background" >> /app/startup.sh && \
    echo "(sleep 20 && /app/.venv/bin/superset db upgrade && /app/.venv/bin/superset fab create-admin --username admin --firstname Admin --lastname User --email godfreyb998@gmail.com --password Admin@2025 && /app/.venv/bin/superset init) &" >> /app/startup.sh && \
    echo "# Start Superset" >> /app/startup.sh && \
    echo "exec /app/docker/docker-bootstrap.sh server" >> /app/startup.sh && \
    chmod +x /app/startup.sh

USER superset

# Use our custom startup script
CMD ["/app/startup.sh"]