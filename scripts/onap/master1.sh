#!/bin/bash

apt update
apt upgrade

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables-save > /etc/iptables.rules

sysctl -w vm.max_map_count=262144

apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
docker version

apt-get update && apt-get install -y apt-transport-https curl
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF
apt-get update
# read -p "Enter PUBKEY in the log above (2 items): " pubkey1 pubkey2
gpg --keyserver keyserver.ubuntu.com --recv-keys 307EA071
gpg --keyserver keyserver.ubuntu.com --recv-keys 836F4BEB
gpg --export --armor 307EA071 | apt-key add -
gpg --export --armor 836F4BEB | apt-key add -
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
swapoff -a

kubeadm config images list

echo "Please check if the images version of kubernetes in master2.sh is correct"
echo "This script mainly install docker and kubernetes."
echo "Next script 'master2.sh'"
