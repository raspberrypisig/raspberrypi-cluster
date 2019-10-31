#!/usr/bin/env bash
set -xe

kubectl get configmap traefik -o yaml -n kube-system|sed -e '/defaultEntryPoints/a\    [api]\n\ \     entryPoint = traefik\n\      dashboard = true' -e '/\[entryPoints\]/a\      \[entryPoints.traefik\]\n\      address = :8080'|kubectl replace -f - 
kubectl rollout restart deployment/traefik
