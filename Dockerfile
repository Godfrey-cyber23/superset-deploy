# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install PyMySQL directly into the virtual environment using system pip
USER root
RUN echo "=== Installing PyMySQL directly into virtual environment ===" && \
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ -r requirements.txt

USER superset

# Use the default command from the base image
# The base image already has a CMD to run the Superset server