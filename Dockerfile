FROM apache/superset:latest

USER root

# Install system dependencies for MySQL connectivity
RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    python3-dev \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install both MySQL drivers for maximum compatibility
RUN pip install --no-cache-dir mysqlclient PyMySQL

# Copy custom configuration
COPY superset_config.py /app/

# Switch to application user
USER superset

# Set environment configuration
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

# Initialize Superset
RUN superset db upgrade && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y && \
    superset init