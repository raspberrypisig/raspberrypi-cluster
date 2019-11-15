#!/usr/bin/env bash
set -xe

# Run as root


# Disable swap
dphys-swapfile swapoff
dphys-swapfile uninstall
systemctl disable dphys-swapfile

# Hack for allowing remote ssh commands to not include banners
su pi bash -c "touch /home/pi/.hushlogin"
rm -f /etc/profile.d/sshpwd.sh

# Install k3s as master node
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_VERSION="v0.11.0-alpha2" sh -s -

sleep 400

kubectl delete storageclass local-path
sleep 10
cat<<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
EOF

#bash zeroconf-avahi/install-avahi-alias.sh
bash zeroconf-avahi/install-avahi-subdomains.sh | tee /home/pi/avahi.log
bash zeroconf-avahi/llmnr.sh | tee /home/pi/llmnr.log
bash manifests/install-manifests.sh | tee /home/pi/manifests.log
bash extras/install-extras.sh | tee /home/pi/extras.log

