FROM apache/superset:latest

USER root

# Install system dependencies required for mysqlclient
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config

# Install MySQL drivers
RUN pip install --no-cache-dir mysqlclient pymysql

# Copy your configuration and scripts
COPY superset_config.py /app/superset_config.py
COPY superset-init.sh /app/
RUN chmod +x /app/superset-init.sh

# --- KEY FIX ---
# Change ownership of the Python packages directory to the superset user
# This allows the non-root 'superset' user to access the installed modules
RUN chown -R superset:superset /usr/local/lib/python3.10/site-packages

# Switch back to the non-root user
USER superset

# Set environment variables
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Command to run the application
CMD ["/app/superset-init.sh"]