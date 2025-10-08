# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration
COPY superset_config.py /app/

# Install system dependencies for mysqlclient and install both MySQL drivers
USER root
RUN echo "=== Installing System Dependencies ===" && \
    apt-get update && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN echo "=== Installing Required Python Packages ===" && \
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ \
    PyMySQL==1.1.0 \
    mysqlclient==2.1.1 \
    flask-cors==4.0.0

RUN echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported')" && \
    /app/.venv/bin/python -c "import MySQLdb; print('SUCCESS: mysqlclient can be imported')" && \
    /app/.venv/bin/python -c "import flask_cors; print('SUCCESS: flask_cors can be imported')"

USER superset