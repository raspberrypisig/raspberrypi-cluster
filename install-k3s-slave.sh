#!/usr/bin/env bash

#Run as root
MASTER_NODE="k3smaster.local"

TOKEN=$( ssh pi@$MASTER_NODE <<'EOF'
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^admin-user/{print $1}') | awk '$1=="token:"{print $2}'
EOF
)

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_NODE:6443 K3S_TOKEN=$TOKEN bash -
CHANNEL=nightly curl -sSL get.docker.com | bash -
