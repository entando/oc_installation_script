#/bin/bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create entando-quickstart --image="rancher/k3s:v1.21.9-k3s1"
kubectl cluster-info
echo "Deploying kubernetes cluster - please wait 2 minute"
sleep 120
curl -sfL https://raw.githubusercontent.com/entando/oc_installation_script/master/entando-k3s-install.sh > installation_script.sh && chmod +x installation_script.sh && ./installation_script.sh entando quickstart
echo ""
echo ""
echo "Short Manual"
echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo "- To list cluster: k3d cluster list"
echo "- To stop cluster: k3d cluster stop <cluster-name>"
echo "- To start cluster: k3d cluster start <cluster-name>"
echo "- To delete cluster: k3d cluster delete <cluster-name>
echo "- To check entando status: kubectl get pods -n entando"
echo "- To get entando ingress: kubectl get ingress -n entando"
