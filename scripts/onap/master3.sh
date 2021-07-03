#!/bin/bash

sudo su

cd ~
git clone -b 8.0.0 http://gerrit.onap.org/r/oom --recurse-submodules
cd oom/kubernetes

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

cp -R ~/oom/kubernetes/helm/plugins/ ~/.local/share/helm/plugins
helm plugin install https://github.com/chartmuseum/helm-push.git

echo "Next Script 'master4.sh'"
echo "master4.sh <worker1_ip><worker2_ip> ... <workerN_ip>"


