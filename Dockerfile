# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install pip in the virtual environment, then install PyMySQL
USER root
RUN echo "=== Setting up Virtual Environment ===" && \
    # Install pip in the virtual environment
    /usr/local/bin/python -m ensurepip && \
    # Upgrade pip in the virtual environment
    /app/.venv/bin/python -m pip install --upgrade pip && \
    echo "=== Installing PyMySQL ===" && \
    # Now use the virtual environment's pip
    /app/.venv/bin/pip install -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL imported successfully')"

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.