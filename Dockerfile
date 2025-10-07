# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install any additional Python packages from your requirements.txt
# Using the virtual environment's pip to ensure packages are available to Superset
RUN /app/.venv/bin/pip install -r requirements.txt

# The base image already has a CMD to run the Superset server, so we don't need to add one.