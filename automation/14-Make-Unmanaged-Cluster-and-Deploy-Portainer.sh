#!/bin/bash
# Setup Portainer
echo '  Preparing for Portainer ...'
# Reference: https://www.portainer.io/

# Versions
#Internal Domain name
DOMAIN_NAME=$(hostname -d)
#Tanzu/Kubernetes cluster name
CLUSTER_NAME='local-cluster'
#Control Plane Name
CONTROL_PLANE="$CLUSTER_NAME"-control-plane
#Location Name
USERD=root
THEHOSTNAME=$(hostname)

# Create Unmanaged Cluster
echo '   Creating Unmanaged Cluster ...'
tanzu um create ${CLUSTER_NAME} -c calico -p 80:80 -p 443:443 -p 9443:9443 -p 30776:30776 -p 30777:30777 -p 30779:30779

# Valideate Cluster is ready
echo "   Validating Unmanaged Cluster $CLUSTER_NAME is Ready ..."
STATUS=NotReady
while [[ $STATUS != "Ready" ]]
do
echo "    Tanzu Cluster $CLUSTER_NAME Status - NotReady"
sleep 10s
STATUS=$(kubectl get nodes -n $CONTROL_PLANE | tail -n +2 | awk '{print $2}')
done
echo "    Tanzu Cluster $CLUSTER_NAME Status - Ready"
kubectl get nodes,po -A
sleep 20s

## Install Portainer
echo "   Adding helm repo for portainer deployment ..."
helm repo add portainer https://portainer.github.io/k8s/
helm repo update

# Create Namespace portainer
echo "   Creating Namespace portainer ..."
kubectl create namespace portainer

# Install Portainer
echo "   Using helm to install portainer ..."
helm install --create-namespace -n portainer portainer portainer/portainer

# Validate that the pod is ready
echo "   Validate that portainer pod is ready ..."
THENAMESPACE="portainer"
THEPOD=$(kubectl get po -n $THENAMESPACE | grep portainer | cut -d " " -f 1)
while [[ $(kubectl get po -n $THENAMESPACE $THEPOD -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "Waiting for pod $THEPOD to be ready" && sleep 1; done
echo "   Pod $THEPOD is now ready ..."

# Show portainer pod info
echo "   portainer pod info: ..."
kubectl get pods -n $THENAMESPACE -o wide
kubectl get services -n $THENAMESPACE -o wide
kubectl describe services -n $THENAMESPACE
kubectl get ingress -n $THENAMESPACE -A

# Echo Completion
sleep 10s
IP_ADDRESS=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
clear
echo "   Portainer pod is deployed ..."
echo "   You can access portainer by going to:"
echo "                                      https://$THEHOSTNAME:30779"
echo "                                      or"
echo "                                      https://$IP_ADDRESS:30779"
echo " "
echo "   Note: You must make a DNS or HOST File entry for $THEHOSTNAME to be able to be accessed"
echo "   More info can be found at https://www.portainer.io/"

sleep 60s
