# raspberrypi-cluster

For testing purposes only.

# Setup Raspbian Buster Lite

### Setup wifi

OPTION 1

```sh
#Run as root
SSID=mycrib
PASSPHRASE=peachspeak38
raspi-config nonint do_wifi_ssid_passphrase $SSID $PASSPHRASE
```

OPTION 2

On SD card, create a wpa-supplicant.conf that looks like this
```text
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="mycrib"
  psk="peachspeak38"
}
```


