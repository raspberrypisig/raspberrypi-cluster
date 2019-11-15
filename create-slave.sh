# Run as root
read -p "Enter new hostname for slave node: " hn
curl -sSL https://raw.githubusercontent.com/raspberrypisig/raspberrypi-cluster/master/get.sh | NODE_ROLE=slave NEWHOSTNAME=$hn bash - | tee slave.log
