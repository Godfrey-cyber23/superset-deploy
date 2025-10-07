# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Switch to root to install packages system-wide
USER root

# Install any additional Python packages from your requirements.txt
RUN pip install -r requirements.txt

# Switch back to superset user for security
USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.