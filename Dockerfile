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

# Copy custom configuration FIRST
COPY superset_config.py /app/

USER superset

# Set environment variable for secret key
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

# Initialize Superset with secure admin credentials
RUN superset db upgrade
RUN superset fab create-admin --username admin --firstname Admin --lastname User --email godfreyb998@gmail.com --password Go1d3fre#y
RUN superset init