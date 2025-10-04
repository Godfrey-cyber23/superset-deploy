FROM apache/superset:latest

# Switch to root to install packages
USER root

# Install system dependencies and MySQL drivers
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config && \
    pip install --no-cache-dir mysqlclient pymysql

# Copy configuration and scripts
COPY superset_config.py /app/superset_config.py
COPY superset-init.sh /app/
RUN chmod +x /app/superset-init.sh

# Switch back to superset user
USER superset

# Set configuration path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Use custom entrypoint
CMD ["/app/superset-init.sh"]