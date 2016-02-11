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

echo "Setup MySQL databases"
mysql -u root -pvagrant -e "DROP USER '$PROJECT_NAME'@'%';"
mysql -u root -pvagrant -e "CREATE USER '$PROJECT_NAME'@'%' IDENTIFIED BY '$PROJECT_NAME'; GRANT ALL ON \`$PROJECT_NAME%\`.* TO '$PROJECT_NAME'@'%'; FLUSH PRIVILEGES;"
mysql -u root -pvagrant -e "DROP DATABASE IF EXISTS $PROJECT_NAME; CREATE DATABASE $PROJECT_NAME CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';"

echo "==== Initializing finished"
