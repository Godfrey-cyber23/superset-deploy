FROM apache/superset:latest

USER root

# Install MySQL client with all required dependencies
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    pkg-config \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install MySQL client using the system packages
RUN pip install mysqlclient

# Copy custom configuration
COPY superset_config.py /app/

USER superset

# Initialize Superset
RUN superset db upgrade
RUN superset fab create-admin --username admin --firstname Admin --lastname User --email admin@example.com --password admin
RUN superset init

# The base image already has the startup command