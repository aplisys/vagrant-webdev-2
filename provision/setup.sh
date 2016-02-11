#!/bin/sh

echo "==== Provisioning virtual machine..."

echo "== Updating APT"

export DEBIAN_FRONTEND=noninteractive

apt-get update

echo "== Upgrading base box"
apt-get -y dist-upgrade

echo "== Installing some tools"
apt-get -y install debconf-utils tmux vim git

echo "== Installing Nginx"
apt-get -y install nginx

echo "== Instaling PHP"
apt-get -y install php7.0 php7.0-fpm php7.0-common php7.0-cli

echo "== Installing PHP extensions"
apt-get -y install php7.0-curl php7.0-gd php7.0-intl php7.0-json php7.0-mcrypt php7.0-mysql php7.0-sqlite3 php7.0-xmlrpc

echo "== Installing MariaDB"

echo "mariadb-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password vagrant" | debconf-set-selections

apt-get -y install mariadb-server

echo "== Setup configuration files"

if [ -f /var/www/provision/config/php-fpm.ini ]
then
    echo "Write PHP-FPM configuration INI file..."
    cp -f /var/www/provision/config/php-fpm.ini /etc/php/7.0/fpm/php.ini
fi

if [ -f /var/www/provision/config/php-fpm.conf ]
then
    echo "Write PHP-FPM configuration CONF file..."
    cp -f /var/www/provision/config/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
fi

if [ -f /var/www/provision/config/php-cli.ini ]
then
    echo "Write PHP-CLI configuration..."
    cp -f /var/www/provision/config/php-cli.ini /etc/php/7.0/cli/php.ini
fi

if [ -f /var/www/provision/config/my.cnf ]
then
    echo "Write MariaDB configuration..."
    cp -f /var/www/provision/config/my.cnf /etc/mysql/my.cnf
fi

systemctl restart mysql php7.0-fpm nginx

echo "== Configure MariaDB root user"
mysql -u root -pvagrant -e "CREATE USER 'root'@'%' IDENTIFIED BY 'vagrant'; GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "== Configure profile"
cp -f /var/www/provision/config/vagrant.sh /etc/profile.d/vagrant.sh

echo "==== Provisioning finished"
