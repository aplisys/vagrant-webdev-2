#!/bin/sh

echo "==== Mounting shared folders on virtual machine..."

if [ ! -d /var/www ]
then
    echo "Create mount point..."
    mkdir -p /var/www
    chown `id -u vagrant`:`id -g vagrant` /var/www
fi

echo "Mount..."
mount -t vboxsf -o auto,uid=`id -u vagrant`,gid=`id -g vagrant` varwww /var/www

echo "==== Mounting finished"
