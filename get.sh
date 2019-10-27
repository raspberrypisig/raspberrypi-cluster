#!/usr/bin/env bash

set -xe

apt update
apt install -y git
git clone https://github.com/raspberrypisig/raspberrypi-cluster
cd raspberrypi-cluster
chmod 744 ./setup-raspbian-lite.sh
./setup-raspbian-lite.sh
test $NODE_ROLE = "master" && ./install-k3s-master.sh  
test $NODE_ROLE = "slave" && ./install-k3s-slave.sh
