# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install system dependencies for mysqlclient and install both MySQL drivers
USER root
RUN echo "=== Installing System Dependencies ===" && \
    apt-get update && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN echo "=== Installing MySQL Drivers ===" && \
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ PyMySQL==1.1.0 mysqlclient==2.1.1

RUN echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported')" && \
    /app/.venv/bin/python -c "import MySQLdb; print('SUCCESS: mysqlclient can be imported')"

USER superset

# Use the default command from the base image