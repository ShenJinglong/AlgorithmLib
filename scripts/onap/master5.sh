
curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
chmod +x ./chartmuseum
mv ./chartmuseum /usr/local/bin

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.yaml

chartmuseum --storage local --storage-local-rootdir ~/helm3-storage -port 8879 &

helm repo add local http://127.0.0.1:8879

helm repo list

whereis helm
read -p "Enter helm path: " HELM_PATH
make SKIP_LINT=TRUE [HELM_BIN=HELM_PATH] all ; make SKIP_LINT=TRUE [HELM_BIN=HELM_PATH] onap

helm repo update
helm search repo onap

cd ~/oom/kubernetes
echo "helm deploy dev local/onap --namespace onap --create-namespace -f onap/resources/overrides/onap-all.yaml -f onap/resources/overrides/environment.yaml --timeout 900s"
helm deploy dev local/onap --namespace onap --create-namespace -f onap/resources/overrides/onap-all.yaml -f onap/resources/overrides/environment.yaml --timeout 900s

echo "Some useful command:"
echo "   kubectl get pods -n onap -o=wide"
echo "   ~/oom/kubernetes/robot/ete-k8s.sh onap health"
