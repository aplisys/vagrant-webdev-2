#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PROJECT_NAME" >&2
  exit 1
fi
export PROJECT_DIR=/var/www
export PROJECT_NAME=$1

cd "$PROJECT_DIR"

echo "==== Initializing project..."

echo "Setup Apache virtual hosts"
if [ -f ./provision/config/000-default.conf ]; then
    rm -f /etc/apache2/sites-enabled/*
    rm -rf ./html
    cp -f ./provision/config/000-default.conf /etc/apache2/sites-available/
    ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
fi

echo "Reload Apache service"
systemctl restart apache2

echo "Setup PostgreSQL databases"
sudo -u postgres psql -c "DROP USER vagrant;"
sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
sudo -u postgres psql -c "CREATE DATABASE vagrant OWNER vagrant;"

echo "==== Initializing finished"
