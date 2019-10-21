#!/usr/bin/env bash

# Run as root

# Hack for allowing remote ssh commands to not include banners
su pi bash -c "touch /home/pi/.hushlogin"
rm /etc/profile.d/sshpwd.sh

apt update

# Install k3s as master node
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" bash -

# create admin-user
cat<<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF

# admin access control
cat<<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF

# token for kubernetes dashboard
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^admin-user/{print $1}') | awk '$1=="token:"{print $2}' > token.txt


