FROM apache/superset:latest

# Switch to root to install packages
USER root

# Install system dependencies and BOTH MySQL drivers for compatibility
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config && \
    pip install --no-cache-dir mysqlclient pymysql

# Copy your custom configuration file into the container
COPY superset_config.py /app/superset_config.py

# Copy the entrypoint script
COPY superset-init.sh /app/
# Make the script executable
RUN chmod +x /app/superset-init.sh

# Switch back to the superset user for security
USER superset

# Set the configuration path
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

# Use the custom script as the entrypoint
CMD ["/app/superset-init.sh"]