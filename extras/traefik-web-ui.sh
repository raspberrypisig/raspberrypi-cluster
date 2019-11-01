#!/usr/bin/env bash
set -x

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
#kubectl get configmap traefik -o yaml -n kube-system|sed -e '/defaultEntryPoints/a\    [api]\n\ \     entryPoint = traefik\n\      dashboard = true' -e '/\[entryPoints\]/a\      \[entryPoints.traefik\]\n\      address = :"8080"'|kubectl apply -f - 
kubectl -n kube-system delete pod $(kubectl -n kube-system get pods | awk '/^traefik/ {print $1}')
#kubectl rollout restart deployment/traefik -n kube-system
