#!/usr/bin/env bash

set -x

# Run as root
if [ ! `id -u` -eq 0 ];
then
  echo "Please run script as root."
  exit 1
fi

if [ $NODE_ROLE = "master" ];
then
  hostname=k3smaster
fi

if [ $NODE_ROLE = "slave" ];
then
  read -p "Enter hostname for slave: " hostname
fi

KEYBOARD=us
LOCALE="en_AU.UTF-8"
TIMEZONE="Australia/Melbourne"

raspi-config nonint do_hostname $hostname
hostnamectl set-hostname $hostname
systemctl restart avahi-daemon

raspi-config nonint do_configure_keyboard $KEYBOARD
raspi-config nonint do_change_locale $LOCALE
raspi-config nonint do_change_timezone $TIMEZONE
raspi-config nonint do_boot_behaviour B2


