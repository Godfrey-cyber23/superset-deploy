FROM apache/superset:latest

# Switch to root to install system dependencies
USER root

# Install system dependencies required for mysqlclient
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config

# Switch to superset user to install the Python package
USER superset

# Install mysqlclient using the superset user's pip
RUN pip install --no-cache-dir mysqlclient

# Copy your custom configuration file into the container
COPY superset_config.py /app/superset_config.py

# Set the secret key environment variable
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

# Run database migrations, create an admin user, and load initial data
RUN superset db upgrade && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y && \
    superset init