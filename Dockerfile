FROM apache/superset:latest

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config

# Install MySQL drivers using the correct pip path
RUN pip install --no-cache-dir mysqlclient pymysql

# Copy your configuration and scripts
COPY superset_config.py /app/superset_config.py
COPY superset-init.sh /app/
RUN chmod +x /app/superset-init.sh

USER superset
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
CMD ["/app/superset-init.sh"]