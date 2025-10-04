FROM apache/superset:latest

USER root

# Install required Python packages
RUN pip install --no-cache-dir flask-cors

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