#!/usr/bin/env bash
set -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

for script in `ls *.sh`
do
  if [ ! $script = $0 ];
  then
    bash "$script"
  fi
done
