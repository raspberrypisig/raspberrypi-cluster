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

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_NODE:6443 K3S_TOKEN=$TOKEN sh -
K3S_SERVER_IP=$(getent ahostsv4 k3smaster|head -1|awk '{print $1}')


cat<<EOF > /etc/init.d/start-k3s-agent
#!/usr/bin/env bash
K3S_SERVER_IP=\$(getent ahostsv4 k3smaster|head -1|awk '{print \$1}')
/usr/local/bin/k3s agent --server https://\$K3S_SERVER_IP:6443 --token $TOKEN                                                                                
EOF


cat<<EOF > /etc/systemd/system/k3s-agent.service
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
After=network-online.target

[Service]
Type=exec
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/etc/init.d/start-k3s-agent

KillMode=process
Delegate=yes
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart k3s-agent
