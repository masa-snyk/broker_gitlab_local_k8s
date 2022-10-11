#!/bin/bash

set -x

### =======================
### Config
### =======================

DOCKER_NETWORK=mySnykBrokerNetwork

GITLAB_HOST=$(cat GITLAB_HOST)  # this name needs to be in SANS of cert. cert name must be the same.
GITLAB_TOKEN=$(cat GITLAB_TOKEN) # Replace this with actual Gitlab token
GITLAB_PASSWORD=Passw0rd

GITLAB_REGISTRY_PORT=5555
GITLAB_REGISTRY_HOST=${GITLAB_HOST}:${GITLAB_REGISTRY_PORT}
GITLAB_CONTAINER_REPO=monitoring

GROUP_ID=$(curl -s --header "Authorization: Bearer ${GITLAB_TOKEN}" -X GET "https://${GITLAB_HOST}/api/v4/groups" | jq -r '.[0].path')

TAG=latest

### =================================
### Push sample code
###  - this will push to default repo
###  - make sure your Gitlab instance is up&running
### =================================

pushd goof

git init --initial-branch=main
git remote add origin https://${GITLAB_HOST}/${GROUP_ID}/Monitoring.git
git add .
git commit -m "Initial commit"
git push -u origin main

popd

### =================================
### Docker build
###  - this will push to default repo
### =================================

echo ${GITLAB_PASSWORD} | docker login -u ${GITLAB_USER} --password-stdin ${GITLAB_REGISTRY_HOST}

pushd goof

docker build -t ${GITLAB_REGISTRY_HOST}/${GROUP_ID}/${GITLAB_CONTAINER_REPO}:${TAG} . 
docker push ${GITLAB_REGISTRY_HOST}/${GROUP_ID}/${GITLAB_CONTAINER_REPO}:${TAG}

popd 

