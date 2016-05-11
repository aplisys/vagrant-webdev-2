#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: \"$0\" project name" >&2
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

if [ -f /etc/php5/cli/conf.d/*-xdebug.ini ]; then
    echo "Disable PHP XDebug module fo CLI"
    rm -f /etc/php5/cli/conf.d/*-xdebug.ini
fi

if [ -f /etc/php5/apache2/conf.d/*-xdebug.ini ]; then
    echo "Disable PHP XDebug module fo Apache2"
    rm -f /etc/php5/apache2/conf.d/*-xdebug.ini
fi

if [ -f /etc/php5/fpm/conf.d/*-xdebug.ini ]; then
    echo "Disable PHP XDebug module fo FPM"
    rm -f /etc/php5/fpm/conf.d/*-xdebug.ini
fi

echo "Reload Apache service"
systemctl restart apache2

echo "Setup MySQL databases"
if [ `mysql -h localhost --port=11306 -u root -pvagrant mysql -e "SELECT COUNT(*) FROM user WHERE User = '$PROJECT_NAME' AND Host = '%'" -N -B` -gt 0 ]; then
    mysql -u root -pvagrant -e "DROP USER '$PROJECT_NAME'@'%';"
fi
mysql -u root -pvagrant -e "CREATE USER '$PROJECT_NAME'@'%' IDENTIFIED BY '$PROJECT_NAME'; GRANT ALL ON \`$PROJECT_NAME%\`.* TO '$PROJECT_NAME'@'%'; FLUSH PRIVILEGES;"
mysql -u root -pvagrant -e "DROP DATABASE IF EXISTS \`$PROJECT_NAME\`; CREATE DATABASE \`$PROJECT_NAME\` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';"

echo "==== Initializing finished"
