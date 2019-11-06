#!/usr/bin/env bash
set -xe

# Run as root


# Disable swap
dphys-swapfile swapoff
dphys-swapfile uninstall
systemctl disable dphys-swapfile

# Hack for allowing remote ssh commands to not include banners
su pi bash -c "touch /home/pi/.hushlogin"
rm /etc/profile.d/sshpwd.sh

# Install k3s as master node
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_VERSION="v0.9.1" sh -s -

sleep 400

#bash zeroconf-avahi/install-avahi-alias.sh
#bash zeroconf-avahi/install-avahi-subdomains.sh
bash manifests/install-manifests.sh
bash extras/install-extras.sh

# Install Kubernetes Dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta5/aio/deploy/alternative.yaml
