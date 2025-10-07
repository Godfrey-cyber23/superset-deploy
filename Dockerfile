# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Debug: Find the correct Python environment
USER root
RUN echo "=== Finding Python Environments ===" && \
    echo "1. All Python executables:" && \
    find / -name "python*" -type f -executable 2>/dev/null | grep -v __pycache__ | head -20 && \
    echo "2. All pip executables:" && \
    find / -name "pip*" -type f -executable 2>/dev/null | grep -v __pycache__ | head -20 && \
    echo "3. Checking common Python locations:" && \
    ls -la /usr/local/bin/python* 2>/dev/null || echo "No python in /usr/local/bin" && \
    ls -la /usr/bin/python* 2>/dev/null || echo "No python in /usr/bin" && \
    echo "4. Current PATH:" && echo $PATH && \
    echo "5. Which python:" && which python && \
    echo "6. Which python3:" && which python3

# Check where Superset is installed
RUN echo "=== Finding Superset Installation ===" && \
    echo "1. Superset command location:" && \
    which superset || echo "superset not in PATH" && \
    echo "2. Finding superset in filesystem:" && \
    find / -name "superset" -type f 2>/dev/null | head -10 && \
    echo "3. Checking Python packages:" && \
    python -c "import superset; print('Superset found at:', superset.__file__)" 2>/dev/null || echo "Cannot import superset"

# Install PyMySQL using the correct Python environment
RUN echo "=== Installing PyMySQL ===" && \
    python -m pip install -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    python -m pip list | grep -i pymysql && \
    python -c "import pymysql; print('SUCCESS: PyMySQL imported successfully')"

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.