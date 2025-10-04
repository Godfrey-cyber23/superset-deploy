FROM apache/superset:latest

# Switch to root to install packages
USER root

# Install system dependencies and the recommended MySQL driver
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config && \
    # Install mysqlclient, the preferred MySQL driver for production:cite[6]
    /app/.venv/bin/pip install --no-cache-dir mysqlclient

# Copy your custom configuration file into the container
COPY superset_config.py /app/superset_config.py

# --- THE ULTIMATE FIX: Use an entrypoint script ---
# Copy the entrypoint script
COPY superset-init.sh /app/
# Make the script executable
RUN chmod +x /app/superset-init.sh

# Switch back to the superset user for security
USER superset

# --- REMOVE HARDCODED SECRETS AND SETUP COMMANDS ---
# The secret key and database setup will be handled via environment variables
# and the entrypoint script. Do not run `superset db upgrade` etc. in the Dockerfile.

# Set the configuration path
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

# Use the custom script as the entrypoint
CMD ["/app/superset-init.sh"]