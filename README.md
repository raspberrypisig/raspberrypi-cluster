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
curl -sSL https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/get.sh | NODE_ROLE=master  bash -
```

# Install K3S on Slave Node
```sh
# Run as root
curl -sSL https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/get.sh | NODE_ROLE=slave  bash -
```

