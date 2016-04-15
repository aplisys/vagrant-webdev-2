#!/bin/sh

echo "==== Installing vboxsf on virtual machine..."

echo "== Updating APT"

printf '#\ndeb http://httpredir.debian.org/debian jessie main contrib non-free\ndeb-src http://httpredir.debian.org/debian jessie main contrib non-free\ndeb http://httpredir.debian.org/debian jessie-updates main contrib non-free\ndeb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free\ndeb http://security.debian.org/ jessie/updates main contrib non-free\ndeb-src http://security.debian.org/ jessie/updates main contrib non-free\n' > ~/sources.list

cp -f ~/sources.list /etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get -y dist-upgrade

apt-get -y install virtualbox-guest-dkms

modprobe -a vboxguest vboxsf vboxvideo

echo "==== Installation finished"
