# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install PyMySQL in the virtual environment using system pip
USER root
RUN echo "=== Installing PyMySQL in Virtual Environment ===" && \
    # Use system pip to install into the virtual environment
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL imported in virtual environment')" && \
    echo "=== Checking installed packages ===" && \
    /app/.venv/bin/python -c \"import pkg_resources; installed_packages = [d for d in pkg_resources.working_set]; mysql_packages = [p for p in installed_packages if 'mysql' in p.key.lower()]; print('MySQL-related packages:', [p.key for p in mysql_packages])\"

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.