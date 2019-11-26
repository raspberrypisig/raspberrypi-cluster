#!/usr/bin/env bash
set -xe

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

curl -s https://api.github.com/repos/vmware-tanzu/octant/releases/latest | grep "browser_download_url.*Linux-ARM\.deb" | cut -d : -f 2,3 | tr -d \" | wget -i -
dpkg -i *.deb

cp octant.service /etc/systemd/system
systemctl daemon-reload
systemctl enable octant
systemctl start octant
