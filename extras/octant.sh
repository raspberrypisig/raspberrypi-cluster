#!/usr/bin/env bash
curl -s https://api.github.com/repos/vmware-tanzu/octant/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | wget -i -
dpkg -i *.deb

#KUBECONFIG=/etc/rancher/k3s/k3s.yaml octant --accepted-hosts 0.0.0.0 --disable-open-browser --listener-addr 0.0.0.0:7777
