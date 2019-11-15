# Run as root
curl -sSL https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/get.sh | NODE_ROLE=master bash - | tee master.log
