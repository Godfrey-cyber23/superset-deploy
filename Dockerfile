# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Install system dependencies for mysqlclient and install both MySQL drivers
USER root
RUN echo "=== Installing System Dependencies ===" && \
    apt-get update && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN echo "=== Installing MySQL Drivers ===" && \
    # Install PyMySQL (pure Python fallback)
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ PyMySQL==1.1.0 && \
    # Try to install mysqlclient (faster, but requires system deps)
    /usr/local/bin/pip install -t /app/.venv/lib/python3.10/site-packages/ mysqlclient==2.1.1 || echo "mysqlclient installation failed, using PyMySQL fallback"

RUN echo "=== Verifying Installation ===" && \
    /app/.venv/bin/python -c "import pymysql; print('SUCCESS: PyMySQL can be imported')" && \
    /app/.venv/bin/python -c \"try:\n import MySQLdb\n print('SUCCESS: mysqlclient can be imported')\nexcept:\n print('mysqlclient not available, using PyMySQL fallback')\"

USER superset

# Use the default command from the base image