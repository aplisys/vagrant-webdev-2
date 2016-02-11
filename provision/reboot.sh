#!/bin/sh

echo "==== Prepare for Symfony project"
echo "Create cache and log dirs"
mkdir -p /dev/shm/www/cache
mkdir -p /dev/shm/www/logs
echo "Chmod cache and log dirs"
setfacl -R -m u:www-data:rwX -m u:vagrant:rwX /dev/shm/www/cache /dev/shm/www/logs
setfacl -dR -m u:www-data:rwX -m u:vagrant:rwX /dev/shm/www/cache /dev/shm/www/logs
echo "==== Preparation finished"
