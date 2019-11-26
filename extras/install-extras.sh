#!/usr/bin/env bash
set -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

bash traefik-web-ui.sh
bash kubectl.sh
bash octant.sh
