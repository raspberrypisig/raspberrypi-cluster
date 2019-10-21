#!/usr/bin/env bash

#Run as root

rm /etc/xdg/autostart/pprompt.desktop

apt update
apt install -y sshpass


MASTER_NODE="k3smaster"

#SSH keyless 
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
SSHPASS=raspberry sshpass -e ssh-copy-id pi@$MASTER_NODE

TOKEN=$( ssh -T -o 'StrictHostKeyChecking no' pi@$MASTER_NODE <<'EOF'
sudo cat /var/lib/rancher/k3s/server/node-token
EOF
)

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_NODE:6443 K3S_TOKEN=$TOKEN sh -

