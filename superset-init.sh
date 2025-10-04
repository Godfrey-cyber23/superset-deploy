#!/bin/bash
# Script to initialize Superset

set -e

# Upgrade the database
superset db upgrade

# Check if the admin user exists, if not, create it
if [ ! -f /app/.admin_created ]; then
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email godfreyb998@gmail.com \
        --password Go1d3fre#y
    touch /app/.admin_created
fi

# Initialize Superset
superset init

# Start the server
exec superset run -p 8088 --with-threads --reload --debugger --host=0.0.0.0