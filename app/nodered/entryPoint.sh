#!/usr/bin/env bash
DIR=$(pwd)
if [ ! -f /data/.setupComplete ];
then
  cd /data
  npm install
  touch /data/.setupComplete
fi

cd $DIR
npm start -- --userDir /data
