#!/usr/bin/env bash

# Run as root
if [ ! `id -u` -eq 0 ];
then
  echo "Please run script as root."
  exit 1
fi

SSID=mycrib
PASSPHRASE=peachspeak38

HOSTNAME=k3smaster
KEYBOARD=us
LOCALE="en_AU.UTF-8"
TIMEZONE="Australia/Melbourne"

raspi-config nonint do_hostname $HOSTNAME
raspi-config nonint do_ssh 0
raspi-config nonint do_configure_keyboard $KEYBOARD
raspi-config nonint do_change_locale $LOCALE
raspi-config nonint do_wifi_ssid_passphrase $SSID $PASSPHRASE
raspi-config nonint do_change_timezone $TIMEZONE
raspi-config nonint do_boot_behaviour B2


