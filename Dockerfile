FROM apache/superset:latest

# Switch to root to install packages
USER root

# Install the MySQL client driver and other dependencies
RUN pip install --no-cache-dir mysqlclient

# Copy your custom configuration file
COPY superset_config.py /app/

# Switch back to the superset user for security
USER superset

# Set the secret key and initialize Superset (your existing commands)
ENV SUPERSET_SECRET_KEY="nWuURhmumjbmbL0Rm9LVIJOGkMsUY7G27rHZpK_7icnwM1_6mFADNCnTq8YOXJ7n2ziX1SwnApM2PRdoBKmG5A"

RUN superset db upgrade && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y && \
    superset init