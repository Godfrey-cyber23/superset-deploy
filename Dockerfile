# Use the official Apache Superset image
FROM apache/superset:latest

# Set the environment variable for the config path
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Copy your custom configuration and requirements
COPY superset_config.py /app/
COPY requirements.txt /app/

# Debug: Check all Python environments and paths
USER root
RUN echo "=== Debugging Python Environments ===" && \
    echo "1. Which python:" && which python && \
    echo "2. Which python3:" && which python3 && \
    echo "3. Python version:" && python --version && \
    echo "4. Python3 version:" && python3 --version && \
    echo "5. Pip version:" && pip --version && \
    echo "6. Pip3 version:" && pip3 --version && \
    echo "7. All Python executables:" && find / -name "python*" -type f -executable 2>/dev/null | grep -v __pycache__ && \
    echo "8. All pip executables:" && find / -name "pip*" -type f -executable 2>/dev/null | grep -v __pycache__ && \
    echo "9. Python path:" && python -c "import sys; print('\n'.join(sys.path))" && \
    echo "10. Current user:" && whoami && \
    echo "11. Home directory:" && echo $HOME && \
    echo "12. Checking if /app/.venv exists:" && ls -la /app/ | grep venv

# Install in all possible Python environments
RUN echo "=== Installing in all Python environments ===" && \
    # Try system Python
    echo "Installing with system pip..." && \
    pip install -r requirements.txt && \
    # Try Python 3 specifically
    echo "Installing with pip3..." && \
    pip3 install -r requirements.txt 2>/dev/null || echo "pip3 not available" && \
    # Try to find and use any virtual environment
    echo "Looking for virtual environments..." && \
    find / -name "pip" -path "*/bin/pip" 2>/dev/null | while read pip_path; do \
        echo "Installing with $pip_path..." && \
        $pip_path install -r requirements.txt; \
    done

# Verify installation in all environments
RUN echo "=== Verifying PyMySQL installation ===" && \
    echo "1. System Python:" && python -c "import pymysql; print('PyMySQL found in system Python')" 2>/dev/null || echo "PyMySQL NOT found in system Python" && \
    echo "2. Python3:" && python3 -c "import pymysql; print('PyMySQL found in Python3')" 2>/dev/null || echo "PyMySQL NOT found in Python3" && \
    # Check all Python executables
    find / -name "python*" -path "*/bin/python*" -type f -executable 2>/dev/null | while read python_path; do \
        echo "Checking $python_path:" && \
        $python_path -c "import pymysql; print('  PyMySQL found')" 2>/dev/null || echo "  PyMySQL NOT found"; \
    done

# List all installed packages to see where PyMySQL ended up
RUN echo "=== Checking installed packages ===" && \
    pip list | grep -i mysql || echo "No MySQL packages in system pip" && \
    find / -name "pymysql*" -type d 2>/dev/null | head -10

USER superset

# The base image already has a CMD to run the Superset server, so we don't need to add one.