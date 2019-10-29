#!/usr/bin/env bash

echo kubectl get configmap traefik -n kube-system -o yaml|sed -r '/\[entryPoints\]/i \ \ \ \ \[api\]\n\ \ \ \ \ \ dashboard=true' | kubectl replace -f -
 kubectl delete pod -n kube-system $(kubectl get pods -n kube-system|awk '$1~/^traefik/ {print $1}')
