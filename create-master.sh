# Run as root
curl -sSL https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/experimental/get.sh | NODE_ROLE=master bash - | tee master.log
