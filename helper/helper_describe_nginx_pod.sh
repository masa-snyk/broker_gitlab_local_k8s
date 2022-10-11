#!/bin/bash

#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

POD=$(kubectl get pod -o name -n ingress-nginx -l app=my-nginx-release-nginx-ingress)

kubectl describe -n ingress-nginx ${POD}
