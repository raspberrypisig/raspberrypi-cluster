#!/usr/bin/env bash
set -xe

# Run as root

apt update
apt install -y git
git clone --branch experimental https://github.com/raspberrypisig/raspberrypi-cluster
cd raspberrypi-cluster
chmod 744 ./setup-raspbian-lite.sh
NODE_ROLE=$NODE_ROLE bash setup-raspbian-lite.sh
test $NODE_ROLE = "master" && bash install-k3s-master.sh  
test $NODE_ROLE = "slave" && bash install-k3s-slave.sh
