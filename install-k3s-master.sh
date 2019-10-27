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

# create admin-user
cat<<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF

# admin access control
cat<<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF

# token for kubernetes dashboard
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^admin-user/{print $1}') | awk '$1=="token:"{print $2}' > token.txt

#Download and run octant
mkdir octant
cd octant
wget https://github.com/raspberrypisig/octant/raw/master/build/octant.xz
xz -d octant.xz
chmod 777 octant
cp octant /usr/local/bin
cd ..
rm -rf octant

# Install Octant service

cat<<EOF > /etc/systemd/system/octant.service
[Unit]
Description=octant
Wants=network.target
Before=network.target

[Service]
Type=simple
Environment=HOME=/root
Environment=KUBECONFIG=/etc/rancher/k3s/k3s.yaml
Environment=OCTANT_DISABLE_OPEN_BROWSER=1
Environment=OCTANT_LISTENER_ADDR=0.0.0.0:7777
ExecStart=/home/pi/octant/build/octant 
WorkingDirectory=/home/pi/octant

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable octant
systemctl start octant


# Install helm
#kubectl apply -f https://github.com/jessestuart/tiller-multiarch/raw/master/manifests/tiller-rbac.yaml
#curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get|bash -
#KUBECONFIG=/etc/rancher/k3s/k3s.yaml helm init --tiller-image=jessestuart/tiller --service-account tiller


