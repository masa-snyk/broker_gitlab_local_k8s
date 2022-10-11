#!/bin/bash

#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

POD=$(kubectl get pod -o name -n snyk-broker -l app.kubernetes.io/name=snyk-broker)

kubectl describe -n snyk-broker ${POD}
