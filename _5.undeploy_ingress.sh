#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

# helm uninstall -n metallb metallb
helm uninstall -n ingress-nginx my-nginx-release 
kubectl delete -f sample/sample_app.yaml
kubectl delete -f ingress_to_broker.yaml -n snyk-broker
