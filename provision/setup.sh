#!/bin/sh

echo "==== Provisioning virtual machine..."

echo "== Updating APT"

export DEBIAN_FRONTEND=noninteractive

apt-get update

echo "== Upgrading base box"
apt-get -y dist-upgrade

echo "== Installing some tools"
apt-get -y install debconf-utils tmux vim git

echo "== Installing Apache 2.4"
apt-get -y install apache2 apache2-mpm-prefork

echo "== Instaling PHP"
apt-get -y install php5 php5-common php5-cli libapache2-mod-php5

echo "== Installing PHP extensions"
apt-get -y install php-pear php5-curl php5-gd php5-intl php5-json php5-mcrypt php5-mysql php5-sqlite php5-xdebug php5-xmlrpc php5-xsl

echo "== Installing MariaDB"

echo "mariadb-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password vagrant" | debconf-set-selections

apt-get -y install mariadb-server

echo "== Setup configuration files"

if [ -f /var/www/provision/config/php-apache2.ini ]
then
    echo "Write PHP for Apache configuration..."
    cp -f /var/www/provision/config/php-apache2.ini /etc/php5/apache2/php.ini
fi

if [ -f /var/www/provision/config/php-cli.ini ]
then
    echo "Write PHP-CLI configuration..."
    cp -f /var/www/provision/config/php-cli.ini /etc/php5/cli/php.ini
fi

echo "Install php composer..."
php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer

echo "Enable apache php module..."
if [ ! -f /etc/apache2/mods-enabled/php5.load ]
then
    ln -s /etc/apache2/mods-available/php5.load /etc/apache2/mods-enabled/php5.load
fi
if [ ! -f /etc/apache2/mods-enabled/php5.conf ] && [ -f /etc/apache2/mods-available/php5.conf ]
then
    ln -s /etc/apache2/mods-available/php5.conf /etc/apache2/mods-enabled/php5.conf
fi
echo "Enable apache rewrite module..."
if [ ! -f /etc/apache2/mods-enabled/rewrite.load ]
then
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
fi
if [ ! -f /etc/apache2/mods-enabled/rewrite.conf ] && [ -f /etc/apache2/mods-available/rewrite.conf ]
then
    ln -s /etc/apache2/mods-available/rewrite.conf /etc/apache2/mods-enabled/rewrite.conf
fi

if [ -f /var/www/provision/config/my.cnf ]
then
    echo "Write MariaDB configuration..."
    cp -f /var/www/provision/config/my.cnf /etc/mysql/my.cnf
fi

systemctl restart mysql apache2

echo "== Configure MariaDB root user"
mysql -u root -pvagrant -e "CREATE USER 'root'@'%' IDENTIFIED BY 'vagrant'; GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "== Configure profile"
cp -f /var/www/provision/config/vagrant.sh /etc/profile.d/vagrant.sh

echo "==== Provisioning finished"
