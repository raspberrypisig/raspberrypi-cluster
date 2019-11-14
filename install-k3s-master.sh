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
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
EOF

#bash zeroconf-avahi/install-avahi-alias.sh
bash zeroconf-avahi/install-avahi-subdomains.sh | tee avahi.log
bash zeroconf-avahi/llmnr.sh | tee llmnr.log
bash manifests/install-manifests.sh | tee manifests.log
bash extras/install-extras.sh | tee extras.log

# Install Kubernetes Dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta5/aio/deploy/alternative.yaml
