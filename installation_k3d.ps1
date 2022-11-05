choco install k3d -y
choco install jq -y
choco install yq -y
choco install kubernetes-helm -y
# Create user profile file if it doesn't exist
if ( -not ( Test-Path $Profile ) ) { New-Item -Path $Profile -Type File -Force }
# Append the k3d completion to the end of the user profile
k3d completion powershell | Out-File -Append $Profile
k3d cluster create entandotest --image="rancher/k3s:v1.21.9-k3s1"
kubectl cluster-info
kubectl get nodes
kubectl create namespace entando
kubectl apply -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.1.1/manifests/k8s-116-and-later/namespace-scoped-deployment/cluster-resources.yaml
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

kubectl apply -n entando -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.1.1/manifests/k8s-116-and-later/namespace-scoped-deployment/namespace-resources.yaml

sleep 10

echo "
apiVersion: entando.org/v1
kind: EntandoApp
metadata:
  namespace: entando
  name: quickstart
spec:
  environmentVariables: []
  dbms: embedded
  ingressHostName: 172.21.0.3.nip.io
  standardServerImage: eap
  replicas: 1" | kubectl apply -f -
