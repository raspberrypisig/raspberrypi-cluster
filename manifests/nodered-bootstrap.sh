if [ ! -f /data/.noderedbootstrap ];
then
  cd /data
  npm install
  touch .noderedbootstrap
fi
