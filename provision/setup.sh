#!/bin/sh

echo "==== Provisioning virtual machine..."

echo "== Updating APT"

export DEBIAN_FRONTEND=noninteractive

apt-get update

echo "== Upgrading base box"
apt-get -y dist-upgrade

echo "== Installing some tools"
apt-get -y install debconf-utils tmux vim git

echo "== Add dotdeb sources"
cp -f /etc/apt/sources.list ~/sources.list
echo "" >> ~/sources.list
echo "deb http://packages.dotdeb.org jessie all" >> ~/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" >> ~/sources.list
cp -f ~/sources.list /etc/apt/sources.list

wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg

apt-get update

echo "== Installing Nginx"
apt-get -y install nginx

echo "== Instaling PHP"
apt-get -y install php7.0 php7.0-fpm php7.0-common php7.0-cli

echo "== Installing PHP extensions"
apt-get -y install php7.0-apcu php7.0-bcmath php7.0-bz2 php7.0-curl php7.0-gd php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring php7.0-mysql php7.0-opcache php7.0-pgsql php7.0-readline php7.0-sqlite3 php7.0-xml php7.0-xmlrpc php7.0-zip php-pear

echo "== Installing MariaDB"

echo "mariadb-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password vagrant" | debconf-set-selections

apt-get -y install mariadb-server

echo "== Setup configuration files"

if [ -f /var/www/provision/config/tmux.conf ]
then
    echo "Write TMUX configuration..."
    cp -f /var/www/provision/config/tmux.conf /etc/tmux.conf
fi

echo "Install php composer..."
php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer

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
