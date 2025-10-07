# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install PyMySQL in the same virtual environment where Superset runs
USER root
RUN echo "=== Installing PyMySQL in Superset's Virtual Environment ===" && \
    # Install using the virtual environment's pip
    /app/.venv/bin/pip install -r requirements.txt && \
    echo "=== Verifying Installation in Virtual Environment ===" && \
    /app/.venv/bin/pip list | grep -i pymysql && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported in virtual environment')"

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.