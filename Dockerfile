FROM apache/superset:latest

# Switch to root for system package installation
USER root

# Install MySQL client dependencies and build tools
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    pkg-config \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install MySQL database driver
RUN pip install --no-cache-dir mysqlclient

# Copy custom configuration
COPY superset_config.py /app/

# Switch to non-privileged user for application execution
USER superset

# Set production secret key
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

# Initialize Superset application
RUN superset db upgrade && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y && \
    superset init