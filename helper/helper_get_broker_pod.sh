#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

kubectl get pod -o name -n snyk-broker -l app.kubernetes.io/name=snyk-broker 
