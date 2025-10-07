# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV PYTHONPATH=/app/.venv/lib/python3.10/site-packages:/app/.local/lib/python3.10/site-packages:$PYTHONPATH

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