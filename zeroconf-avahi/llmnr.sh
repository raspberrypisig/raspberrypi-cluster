#!/usr/bin/env bash
cp llmnr.py /usr/local/bin
cp llmnr.service /etc/system/system
mkdir -p /etc/llmnr
cp SUBDOMAINS_K3SMASTER /etc/llmnr
systemctl daemon-reload
systemctl enable llmnr
systemctl start llmnr
