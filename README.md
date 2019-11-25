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

File available [here](https://github.com/raspberrypisig/raspberrypi-cluster/raw/master/wpa_supplicant.conf)

### Step 2: Setup SSH

On SD card, create an empty file called ssh

### Step 3: Copy master or slave script
Copy either [master script](https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/create-master.sh) or
[slave script](https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/create-slave.sh) to SD card 


# Install K3S on Master Node

Boot into Raspbian, then execute

```sh
# Run as root
apt update
bash /boot/create-master.sh
```

# Install K3S on Slave Node

Boot into Raspbian, then execute
```sh
# Run as root
apt update
bash /boot/create-slave.sh
```

# Confirmation of working cluster on Raspberry pi

On master node, run:

```sh
kubectl get nodes
```

There is a pod on the cluster running nginx with a list of other pods/services running on the cluster. To get to it, you can use
a device on the same wifi network and type the following in the browser depending on whether you are running Windows 10 or not.

### Windows 10 Desktop/PC

http://nginx-k3smaster.local

### Linux/MacOS/Android/iOS

http://nginx.k3smaster.local

![Raspberry Pi Cluster Services](https://github.com/raspberrypisig/raspberrypi-cluster/raw/master/app/nginx/cluster-pi-services.jpg)

