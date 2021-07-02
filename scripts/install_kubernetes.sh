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
images=(
    kube-apiserver:v1.20.1
    kube-controller-manager:v1.20.1
    kube-scheduler:v1.20.1
    kube-proxy:v1.20.1
    pause:3.2
    etcd:3.4.13-0
)
for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
    docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.7.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.7.0 k8s.gcr.io/coredns/coredns:v1.7.0
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.7.0

