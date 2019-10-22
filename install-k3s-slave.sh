#!/usr/bin/env bash

#Run as root

rm /etc/xdg/autostart/pprompt.desktop

apt update
apt install -y sshpass


MASTER_NODE="k3smaster.local"

#SSH keyless 
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
`SSHPASS=raspberry sshpass -e ssh-copy-id -f pi@$MASTER_NODE`
ssh -T -o StrictHostKeyChecking=no pi@$MASTER_NODE exit

TOKEN=$( ssh -T -o StrictHostKeyChecking=no pi@$MASTER_NODE <<'EOF'
sudo cat /var/lib/rancher/k3s/server/node-token
EOF
)

K3S_SERVER_IP=$(getent ahostsv4 $MASTER_NODE|head -1|awk '{print $1}')
curl -sfL https://get.k3s.io | K3S_URL=https://$K3S_SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -

cat<<EOF > /etc/init.d/hack-k3s
#!/usr/bin/env bash
K3S_SERVER_IP=\$(getent ahostsv4 \$MASTER_NODE|head -1|awk '{print \$1}')
sed -ri "s/K3S_TOKEN=[0-9.]+/K3S_TOKEN=\$K3S_SERVER_IP/" /etc/systemd/system/k3s-agent.service.env
EOF
chmod 777 /etc/init.d/hack-k3s

cat<<EOF > /etc/systemd/system/hack-k3s.service
[Unit]
Description=Hack needed because k3s cannot resolve k3smaster
Before=k3s-agent.service

[Service]
Type=simple
ExecStart=/etc/init.d/hack-k3s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable hack-k3s
reboot


