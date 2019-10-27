#!/usr/bin/env bash

raspi-config nonint do_hostname k3smaster
raspi-config nonint do_ssh 0
raspi-config nonint do_configure_keyboard us
raspi-config nonint do_change_locale en_AU.UTF-8
raspi-config nonint do_wifi_ssid_passphrase SSID passphrase
raspi-config nonint do_change_timezone Australia/Melbourne
raspi-config nonint do_boot_behaviour B2


