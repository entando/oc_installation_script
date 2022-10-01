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
curl -s https://raw.githubusercontent.com/entando/oc_installation_script/master/entando-k3s-install.sh > installation_script.sh
./installation_script.sh entando quickstart
