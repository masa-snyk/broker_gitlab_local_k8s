#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

### Deply MetalLB (for local/baremetal K8s cluster)
# 
# MacOS doesn't support MetalLB because Docker network is not exposed to baremetal K8s
#

# helm repo add metallb https://metallb.github.io/metallb
# helm upgade
# 
# helm upgrade --install metallb metallb/metallb \
#   -n metallb --create-namespace \
#   --wait
# 
# METALLB_IPADDRESS=$(ipconfig getifaddr en0)
# 
# cat <<EOF | kubectl apply -f -
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   namespace: metallb
#   name: config
# data:
#   config: |
#     address-pools:
#     - name: default
#       protocol: layer2
#       addresses:
#       - 172.18.99.100-172.18.99.150
# EOF

### Deploy Nginx ingress controller 
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
 
helm upgrade --install my-nginx-release nginx-stable/nginx-ingress \
  -n ingress-nginx --create-namespace

kubectl wait \
  --for=condition=ready pod \
  -n ingress-nginx \
  --selector=app=my-nginx-release-nginx-ingress \
  --timeout=300s

### Deploy Kong ingress controller 
# kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/master/deploy/single/all-in-one-dbless.yaml
# 
# kubectl wait --namespace kong \
#   --for=condition=ready pod \
#   --selector=app.kubernetes.io/component=controller \
#   --timeout=300s

 
### Deploy Contour ingress controller (Contour)
# kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
# 
# kubectl wait --namespace projectcontour \
#   --for=condition=available deployment/contour \
#   --timeout=90s
# 
# # kind specific (not necesarry for other k8s)
# kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/control-plane","operator":"Equal","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'


# Sample apps (Optional)
kubectl apply -f sample/sample_app.yaml

# deploy ingress
kubectl apply -f ingress_to_broker.yaml -n snyk-broker

kubectl wait \
  --for=condition=ready pod \
  -n snyk-broker \
  --selector=app.kubernetes.io/name=snyk-broker \
  --timeout=300s

sudo kubectl port-forward -n ingress-nginx service/my-nginx-release-nginx-ingress 80:80
