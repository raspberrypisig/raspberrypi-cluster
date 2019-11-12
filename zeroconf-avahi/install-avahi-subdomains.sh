#!/usr/bin/env bash

set -xe

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

apt install -y avahi-utils
sed -ri 's/.*allow-interfaces.*/allow-interfaces=eth0,wlan0/' /etc/avahi/avahi-daemon.conf
systemctl restart avahi-daemon

mkdir -p /etc/avahi-subdomains
cp SUBDOMAINS_K3SMASTER /etc/avahi-subdomains

cat<<EOF > /usr/local/bin/avahi-subdomain
#!/usr/bin/env bash
sleep 30
IP="\$(getent ahostsv4 k3smaster.local | head -1 | awk '{print \$1}')"
SUBDOMAINS="\$(cat /etc/avahi-subdomains/SUBDOMAINS_K3SMASTER)"
for subdomain in \$SUBDOMAINS
do
  avahi-publish-address -R \${subdomain}.k3smaster.local \$IP &
done

while true
do
sleep 30
done
EOF

chmod 755 /usr/local/bin/avahi-subdomain

cat<<EOF > /etc/systemd/system/avahi-subdomain.service
[Unit]
Description=Avahi Subdomains
Requires=avahi-daemon.service

[Service]
Type=simple
ExecStart=/usr/local/bin/avahi-subdomain

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable avahi-subdomain
systemctl start avahi-subdomain


