# Dockerfile

FROM apache/superset:latest

# Switch to root to install packages
USER root

# Install system dependencies required for pymysql
RUN apt-get update && \
    apt-get install -y python3-dev default-libmysqlclient-dev build-essential

# Install the MySQL client driver (pymysql)
RUN pip install --no-cache-dir pymysql

# Copy your custom configuration file into the container
COPY superset_config.py /app/superset_config.py

# Switch back to the superset user for security
USER superset

# Set the secret key environment variable
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

# Run database migrations, create an admin user, and load initial data
# Note: The syntax error from your original file has been fixed here.
RUN superset db upgrade && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y && \
    superset init