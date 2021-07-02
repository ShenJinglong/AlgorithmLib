#!/bin/bash


apt update
apt upgrade

apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
docker version

apt install -y git expect nodejs npm jq
apt install -y python3-pip

service docker start

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm plugin install https://github.com/chartmuseum/helm-push

cd /tmp
git clone https://gerrit.onap.org/r/oom/offline-installer onap-offline
cd onap-offline

pip3 install -r ./build/requirements.txt
pip3 install -r ./build/download/requirements.txt

git clone https://gerrit.onap.org/r/oom -b honolulu --recurse-submodules /tmp/oom
./build/creating_data/docker-images-collector.sh /tmp/oom/kubernetes/onap

cd /tmp
./onap-offline/build/create_repo.sh -d $(pwd) -t ubuntu

cd onap-offline
./build/download/download.py --docker ./build/data_lists/infra_docker_images.list ../resources/offline_data/docker_images_infra --http ./build/data_lists/infra_bin_utils.list ../resources/downloads

./build/download/download.py --docker ./build/data_lists/rke_docker_images.list --docker ./build/data_lists/k8s_docker_images.list --docker ./build/data_lists/onap_docker_images.list