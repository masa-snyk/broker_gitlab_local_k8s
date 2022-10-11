#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

### Config

GITLAB_HOST=$(cat GITLAB_HOST)
GITLAB_TOKEN=$(cat GITLAB_TOKEN)

SCM_TYPE=gitlab
BROKER_TOKEN=$(cat BROKER_TOKEN)
BROKER_CLIENT_URL=http://broker.test:80
BROKER_CLIENT_PORT=8000

ACCEPT_JSON_FILE=accept.json
ROOT_CA_CERT=volume/config/ssl/rootCA.pem

# Hack: custom image (curl installed)
# BROKER_IMAGE=itmstm/masa-broker
BROKER_IMAGE=snyk/broker

### Helm

helm repo add snyk-broker https://snyk.github.io/snyk-broker-helm/ 
helm repo update
helm pull --untar snyk-broker/snyk-broker

### Prep
# accept.json and certs need to be under directory where Chart.yml resides.
# These files are read by helm and added to configmap.
#
cp ${ACCEPT_JSON_FILE} snyk-broker/accept.json
cp ${ROOT_CA_CERT} snyk-broker/

### Help install (upgrade)
#
# Hack: run as root so that you can install curl/git for debug purpose.
#   --set securityContext.readOnlyRootFilesystem=false \
#   --set securityContext.allowPrivilegeEscalation=true \
#   --set securityContext.runAsNonRoot=false \
#   --set securityContext.runAsUser=0 \
#

helm upgrade --install my-broker-chart ./snyk-broker \
   --set scmType=${SCM_TYPE} \
   --set brokerToken=${BROKER_TOKEN} \
   --set gitlab=${GITLAB_HOST} \
   --set scmToken=${GITLAB_TOKEN} \
   --set brokerClientUrl=${BROKER_CLIENT_URL} \
   --set deployment.container.containerPort=${BROKER_CLIENT_PORT} \
   --set service.port=${BROKER_CLIENT_PORT} \
   --set logLevel=debug \
   --set acceptJsonFile=accept.json \
   --set image.repository=${BROKER_IMAGE} \
   --set tlsRejectUnauthorized=0 \
   --set caCert=$(basename ${ROOT_CA_CERT}) \
   -n snyk-broker --create-namespace \
   --wait


   # --set caCert=${ROOT_CA_CERT} \

