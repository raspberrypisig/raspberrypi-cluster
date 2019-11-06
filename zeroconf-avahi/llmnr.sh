#!/usr/bin/env bash
cp llmnr.py /usr/local/bin
cp llmnr.service /etc/system/system
systemctl daemon-reload
systemctl enable llmnr
systemctl start llmnr
