#!/bin/bash
#  Author
#  Sergio Molino
#
#  This script install Entando application on EKS (AWS)
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
echo "Installing ingress"
echo ""
echo "##################################################################################"
echo "##################################################################################"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/aws/deploy.yaml
echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace $namespace"
echo ""
echo "##################################################################################"
echo "##################################################################################"
kubectl create namespace $namespace


echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Applying Config Map"
echo ""
echo "##################################################################################"
echo "##################################################################################"

echo -e "
kind: ConfigMap
apiVersion: v1
metadata:
  name: entando-operator-config
  namespace: entando
data:
  entando.ingress.class: 'nginx'"
  entando.requires.filesystem.group.override: 'true'" | kubectl apply -f -


echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Cluster Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

kubectl apply -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.1.0/manifests/k8s-116-and-later/namespace-scoped-deployment/cluster-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

kubectl apply -n $namespace -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.1.0/manifests/k8s-116-and-later/namespace-scoped-deployment/namespace-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Deploying Applicaton $appname"
echo ""
echo "##################################################################################"
echo "##################################################################################"
sleep 10
kubectl get svc -n ingress-nginx | grep LoadBalancer | awk '{print $4}' | while read HOST;do
echo -e "
apiVersion: entando.org/v1
kind: EntandoApp
metadata:
  namespace: $namespace
  name: $appname
spec:
  environmentVariables: []
  dbms: embedded
  ingressHostName: $HOST
  standardServerImage: eap
  replicas: 1" | kubectl apply -f -; done
echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Namespace $namespace is created and $appname application is deploying"
echo "Wait around 10 minutes, when application is deployed it is available at:"
echo ""
kubectl get svc -n ingress-nginx | grep LoadBalancer | awk '{print $4}' |while read HOST;do
echo "http://$HOST/app-builder/";done
echo ""
echo "##################################################################################"
echo "##################################################################################"
