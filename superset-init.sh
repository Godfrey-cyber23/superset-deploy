#!/bin/bash
set -e

echo "Checking Python environment and installed packages..."
/app/.venv/bin/python -c "import pymysql; print('PyMySQL successfully imported')"
/app/.venv/bin/python -c "import mysqlclient; print('mysqlclient successfully imported')"

echo "Waiting for database to be ready..."
sleep 5

echo "Upgrading database schema..."
superset db upgrade

echo "Creating admin user if needed..."
if ! superset fab list-users | grep -q "admin"; then
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y
    echo "Admin user created"
else
    echo "Admin user already exists"
fi

echo "Initializing Superset..."
superset init

echo "Starting Superset server..."
exec superset run -p 8088 --with-threads --reload --debugger --host=0.0.0.0