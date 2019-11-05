#!/usr/bin/env bash
set -x

while true
do
  isReady=$(kubectl -n kube-system get deployment traefik -o jsonpath='{.status.readyReplicas}')
  if [ -n $isready ];
  then
    break
  fi
  sleep 30
done

while true
do
  kubectl -n kube-system get configmap traefik 2>/dev/null >/dev/null
  if [ $? -eq 0 ];
  then
    break
  fi
  sleep 30
done

kubectl -n kube-system patch configmap traefik --patch "$(cat traefik-patch.yaml)" 
kubectl -n kube-system delete pod $(kubectl -n kube-system get pods | awk '/^traefik/ {print $1}')
sleep 60

cat<<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: traefik-web-ingress
  namespace: kube-system
spec:
  rules:
  - host: traefik-k3smaster.local
    http:
      paths:
      - path: /
        backend:
          serviceName: traefik
          servicePort: 8080
  - host: traefik.k3smaster.local
    http:
      paths:
      - path: /
        backend:
          serviceName: traefik
          servicePort: 8080
EOF
