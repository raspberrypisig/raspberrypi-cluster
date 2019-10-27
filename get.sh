#!/usr/bin/env bash

set -xe

apt update
apt install -y git
git clone https://github.com/raspberrypisig/raspberrypi-cluster
cd raspberrypi-cluster
chmod 744 ./setup-raspbian-lite.sh
./setup-raspbian-lite.sh
$NODE_ROLE = "MASTER" && ./install-k3s-master.sh  
$NODE_ROLE = "SLAVE" && ./install-k3s-slave.sh
