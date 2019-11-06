#!/usr/bin/env bash
set -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

cp llmnr.py /usr/local/bin
cp llmnr.service /etc/system/system
mkdir -p /etc/llmnr
cp SUBDOMAINS_K3SMASTER /etc/llmnr
systemctl daemon-reload
systemctl enable llmnr
systemctl start llmnr
