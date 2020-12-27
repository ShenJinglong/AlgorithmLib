#!/bin/bash

echo "[NOTICE] this script only handle issues that I met in the installation progress."

echo "setting iptables ..."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables-save > /etc/iptables.rules
echo "finished ..."

echo "setting virtual memory ..."
sysctl -w vm.max_map_count=262144
echo "finished ..."

apt update

echo "installing docker ..."
apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
docker version
echo "finished ..."

echo "installing kubernetes ..."
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
images=(
    kube-apiserver:v1.20.1
    kube-controller-manager:v1.20.1
    kube-scheduler:v1.20.1
    kube-proxy:v1.20.1
    pause:3.2
    etcd:3.4.13-0
    coredns:1.7.0
)
for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
    docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done
kubeadm init --pod-network-cidr=10.244.0.0/16
echo "finished ..."
