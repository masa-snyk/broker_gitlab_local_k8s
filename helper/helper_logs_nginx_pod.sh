#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

kubectl logs -n ingress-nginx $(kubectl get pod -n ingress-nginx -o jsonpath={.items[0].metadata.name}) 
