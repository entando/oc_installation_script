#!/bin/bash -x
date

### 0. Install helm, kubectl (kubernetes-cli), and k3d with brew
brew install helm k3d kubectl

### 1. Create a cluster with k3d that connects port 443 to the loadbalancer provided by k3d
# Optionally install with more agents `--agents 3`
k3d cluster create k3d-rancher \
    --api-port 6550 \
    --servers 1 \
    --image rancher/k3s:v1.21.9-k3s1 \
    --port 443:443@loadbalancer \
    --wait --verbose
k3d cluster list
date

### 2. Set up a kubeconfig so you can use kubectl in your current session
KUBECONFIG_FILE=~/.kube/k3d-rancher
k3d kubeconfig get k3d-rancher > $KUBECONFIG_FILE
chmod 600 $KUBECONFIG_FILE
export KUBECONFIG=$KUBECONFIG_FILE
kubectl get nodes

### 3. Install cert-manager with helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v1.5.3 \
    --set installCRDs=true --wait --debug
kubectl -n cert-manager rollout status deploy/cert-manager
date

### 4. Install the helm repos for rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --version=2.6.1 \
    --set hostname=rancher.localhost \
    --set bootstrapPassword=congratsthanandayme \
    --wait --debug
kubectl -n cattle-system rollout status deploy/rancher
kubectl -n cattle-system get all,ing
date
curl -sfL https://raw.githubusercontent.com/entando/oc_installation_script/master/entando-k3s-install.sh > installation_script.sh && chmod +x installation_script.sh && ./installation_script.sh entando quickstart
echo https://rancher.localhost/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}')
