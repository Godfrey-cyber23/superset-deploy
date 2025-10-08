# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install both MySQL drivers
USER root
RUN apt-get update && apt-get install -y default-libmysqlclient-dev build-essential && \
    pip install -r requirements.txt

USER superset

# Use the default command from the base image