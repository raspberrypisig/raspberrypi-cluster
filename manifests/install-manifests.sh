#!/usr/bin/env bash
set -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
for manifest in `ls *.yaml`
do
  kubectl create -f $manifest
done
