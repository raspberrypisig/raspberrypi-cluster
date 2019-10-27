# raspberrypi-cluster

For testing purposes only.

# Setup Raspbian Buster Lite

### Setup wifi

On SD card, create a wpa-supplicant.conf that looks like this
```text
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="mycrib"
  psk="peachspeak38"
}
```

### Setup SSH

On SD card, create an empty file called ssh

# Install K3S on Master Node

```sh
# Run as root
curl -sSL http://bit.ly/31VNeXu | NODE_ROLE=master  bash -
```

# Install K3S on Slave Node
```sh
# Run as root
curl -sSL http://bit.ly/31VNeXu | NODE_ROLE=slave  bash -
```

