#!/usr/bin/env bash

set -xe

cd /tmp
apt update
apt install -y git
git clone https://github.com/raspberrypisig/raspberrypi-cluster
cd raspberrypi-cluster
chmod 744 ./setup-raspbian-lite.sh
./setup-raspbian-lite.sh
test $NODE_ROLE = "master" && bash install-k3s-master.sh  
test $NODE_ROLE = "slave" && bash install-k3s-slave.sh
