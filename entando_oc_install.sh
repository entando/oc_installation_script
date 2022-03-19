#!/bin/bash
#  Author
#  Sergio Molino
#
#  This script install Entando application on Openshift4
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
kubectl create namespace $namespace
echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Cluster Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

./oc apply -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.0.0-pre4/manifests/k8s-116-and-later/namespace-scoped-deployment/cluster-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Creating Namespace Resources"
echo ""
echo "##################################################################################"
echo "##################################################################################"

./oc apply -n $namespace -f https://raw.githubusercontent.com/entando-k8s/entando-k8s-operator-bundle/v7.0.0-pre4/manifests/k8s-116-and-later/namespace-scoped-deployment/namespace-resources.yaml

echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Deploying Applicaton $appname"
echo ""
echo "##################################################################################"
echo "##################################################################################"

./oc get routes -n openshift-console | grep console.openshift-console.apps | awk '{print $2}' | sed 's/console-openshift-console//g' | while read HOST;do 
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
  ingressHostName: $appname$HOST
  standardServerImage: eap
  replicas: 1" | ./oc apply -f -; done
echo ""
echo "##################################################################################"
echo "##################################################################################"
echo ""
echo "Namespace $namespace is created and $appname application is deploying"
echo "Wait around 10 minutes, when application is deployed it is available at:"
echo ""
./oc get routes -n openshift-console | grep console.openshift-console.apps | awk '{print $2}' | sed 's/console-openshift-console//g' | while read HOST;do 
echo "http://$appname$HOST/app-builder/";done
echo ""
echo "##################################################################################"
echo "##################################################################################"
