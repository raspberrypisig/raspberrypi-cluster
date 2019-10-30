#!/usr/bin/env bash
set -xe

apt install -y python-avahi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
install -m 755 avahi-alias.py /usr/local/bin
cp avahi-alias.service /etc/systemd/system/
hosts=$(cat HOSTNAMES)
sed -ri "s/HOSTNAMES/$hosts/" /etc/systemd/system/avahi-alias.service
systemctl daemon-reload
systemctl enable avahi-alias
systemctl start avahi-alias

