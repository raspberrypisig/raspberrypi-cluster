#!/usr/bin/env bash

set -xe

# Run as root
if [ ! `id -u` -eq 0 ];
then
  echo "Please run script as root."
  exit 1
fi

if [ $NODE_ROLE = 'master' ];
then
  HOSTNAME=k3smaster
fi

if [ $NODE_ROLE = 'slave' ];
then
  read -p "Enter hostname for slave: " HOSTNAME
fi

KEYBOARD=us
LOCALE="en_AU.UTF-8"
TIMEZONE="Australia/Melbourne"

raspi-config nonint do_hostname $HOSTNAME
hostnamectl set-hostname $HOSTNAME
systemctl restart avahi-daemon

raspi-config nonint do_configure_keyboard $KEYBOARD
raspi-config nonint do_change_locale $LOCALE
raspi-config nonint do_change_timezone $TIMEZONE
raspi-config nonint do_boot_behaviour B2


