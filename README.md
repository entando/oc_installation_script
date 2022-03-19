# oc_installation_script
Automated script to Deploy Entando on Openshift4

# Requirement
- oc installed
- Logged ad amin on openshift

# Steps to launch the scirpt

curl -sLO  "https://github.com/entando/oc_installation_script/raw/master/entando_oc_install.sh" && chmod +x ./entando_oc_install.sh && ./entando_oc_install.sh $namespace $appname

es:

curl -sLO  "https://github.com/entando/oc_installation_script/raw/master/entando_oc_install.sh" && chmod +x ./entando_oc_install.sh && ./entando_oc_install.sh entando quickstart

That script creates a namespace called "entando" and an appname named "quickstart"