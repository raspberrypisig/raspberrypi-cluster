# raspberrypi-cluster

For testing purposes only.

Setup will create 2 node Kubernetes cluster. Tested on Raspberry Pi 3B and B+. 

# Setup Raspbian Buster Lite

Start with a fresh Raspbian.

### Step1: Setup wifi

On SD card, create a wpa_supplicant.conf that looks like this
```text
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=AU

network={
  ssid="mycrib"
  psk="peachspeak38"
}
```

### Step 2: Setup SSH

On SD card, create an empty file called ssh

### Step 3: Copy master or slave script
Copy either [master script](https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/create-master.sh) or
[slave script](https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/create-slave.sh) to SD card 


# Install K3S on Master Node

Boot into Raspbian, then execute

```sh
# Run as root
bash /boot/create-master.sh | tee master.log
```

# Install K3S on Slave Node

Boot into Raspbian, then execute
```sh
# Run as root
bash /boot/create-slave.sh | tee slave.log
```

