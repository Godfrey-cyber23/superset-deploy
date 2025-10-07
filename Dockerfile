# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Debug: Check environment and install PyMySQL
USER root
RUN echo "=== Debugging Environment ===" && \
    echo "1. Current user:" && whoami && \
    echo "2. Python version:" && python --version && \
    echo "3. Pip version:" && pip --version && \
    echo "4. Python path:" && python -c "import sys; print('\n'.join(sys.path))" && \
    echo "5. Checking if Superset config exists:" && ls -la /app/superset_config.py && \
    echo "6. Checking requirements.txt:" && cat /app/requirements.txt

# Install PyMySQL (pure Python, no system dependencies needed)
RUN echo "=== Installing PyMySQL ===" && \
    pip install -r requirements.txt && \
    echo "=== Verifying Installation ===" && \
    pip list | grep -i pymysql && \
    python -c "import pymysql; print('SUCCESS: PyMySQL imported successfully')" && \
    echo "=== Checking Superset Python Environment ===" && \
    python -c "import superset; print('Superset path:', superset.__file__)" 2>/dev/null || echo "Superset not importable in this context"

# Additional debug: Check if we can find where superset runs from
RUN echo "=== Finding Superset Executable ===" && \
    which superset || echo "superset command not found in PATH" && \
    find /app -name "*.py" -path "*/superset/*" 2>/dev/null | head -5

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.