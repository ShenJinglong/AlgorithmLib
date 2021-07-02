#!/bin/bash

apt-get update && apt-get install -y apt-transport-https curl
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF
apt-get update
read -p "Enter PUBKEY in the log above (2 items): " pubkey1 pubkey2
gpg --keyserver keyserver.ubuntu.com --recv-keys $pubkey1
gpg --keyserver keyserver.ubuntu.com --recv-keys $pubkey2
gpg --export --armor $pubkey1 | apt-key add -
gpg --export --armor $pubkey2 | apt-key add -
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
swapoff -a

kubeadm config images list


