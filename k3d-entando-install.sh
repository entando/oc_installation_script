#/bin/bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create entando-quickstart --image="rancher/k3s:v1.21.9-k3s1"
kubectl cluster-info
echo "Deploying kubernetes cluster - please wait 1 minute"
sleep 120
curl -sfL https://raw.githubusercontent.com/entando/oc_installation_script/master/entando-k3s-install.sh > installation_script.sh && chmod +x installation_script.sh && ./installation_script.sh entando quickstart
