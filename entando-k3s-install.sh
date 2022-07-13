#!/bin/bash
#  Author
#  Sergio Molino
#
#  This script install Entando application on k3s
#
namespace=$1
appname=$2

if [[ -z "$namespace" ]]; then
        echo "Use "$(basename "$0")" NAMESPACE";
        exit 1;
fi
if [[ -z "$appname" ]]; then
        echo "Use "$(basename "$0")" APPNAME";
        exit 1;
fi

echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace $namespace"
echo ""
echo "##################################################################################"
echo "##################################################################################"
sudo kubectl create namespace $namespace


echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Applying Config Map"
echo ""
echo "##################################################################################"
echo "##################################################################################"

echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Cluster Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

sudo kubectl apply -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.0.0/manifests/k8s-116-and-later/namespace-scoped-deployment/cluster-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

sudo kubectl apply -n $namespace -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.0.0/manifests/k8s-116-and-later/namespace-scoped-deployment/namespace-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Deploying Applicaton $appname"
echo ""
echo "##################################################################################"
echo "##################################################################################"
sleep 10
sudo kubectl get svc -n ingress-nginx | grep LoadBalancer | awk '{print $4}' | while read HOST;do
echo -e "
apiVersion: entando.org/v1
kind: EntandoApp
metadata:
  namespace: $namespace
  name: $appname
spec:
  environmentVariables: []
  entandoAppVersion: '7.0'
  dbms: embedded
  ingressHostName: $HOST
  standardServerImage: eap
  replicas: 1" | sudo kubectl apply -f -; done