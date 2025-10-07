FROM apache/superset:latest

ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

COPY superset_config.py /app/
COPY requirements.txt /app/

USER root

# Install system dependencies for mysqlclient
RUN apt-get update && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install -r requirements.txt

USER superset