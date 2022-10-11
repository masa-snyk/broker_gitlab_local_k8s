#!/bin/bash

set -x

docker rm -f gitlab
 
rm -rf ./goof/.git

./_5.undeploy_ingress.sh
./_4.undeploy_broker.sh
./_3.delete_kind_cluster.sh

# rm -rf volume snyk-broker
