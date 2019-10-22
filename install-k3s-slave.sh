#!/usr/bin/env bash

#Run as root

rm /etc/xdg/autostart/pprompt.desktop

apt update
apt install -y sshpass


MASTER_NODE="k3smaster.local"

#SSH keyless 
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
SSHPASS=raspberry sshpass -e ssh-copy-id -f pi@$MASTER_NODE

TOKEN=$( ssh -T -o StrictHostKeyChecking=no pi@$MASTER_NODE <<'EOF'
sudo cat /var/lib/rancher/k3s/server/node-token
EOF
)

K3S_SERVER_IP=$(getent ahostsv4 $MASTER_NODE|head -1|awk '{print $1}')
curl -sfL https://get.k3s.io | K3S_URL=https://$K3S_SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -

sed -ri "s/K3S_TOKEN=[0-9.]+/K3S_TOKEN=$K3S_SERVER_IP/" /etc/systemd/system/k3s-agent.service.env




