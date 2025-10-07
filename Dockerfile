# Use the official Apache Superset image
# It's good practice to pin a version for production, e.g., apache/superset:3.1.0
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Fix pip cache permissions and install packages
USER root
RUN mkdir -p /app/superset_home/.cache/pip && \
    chown -R superset:superset /app/superset_home/.cache
USER superset

# Install any additional Python packages from your requirements.txt
RUN pip install --user -r requirements.txt

# The base image already has a CMD to run the Superset server, so we don't need to add one.