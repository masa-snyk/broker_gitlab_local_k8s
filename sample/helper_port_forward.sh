#!/bin/bash

#if [ $# -ne 0 ]
#	then
#		echo 'Needs to supply argument'
#		echo '  $1 = <arg>'
#		exit 1
#fi

set -x

sudo kubectl port-forward -n ingress-nginx service/my-nginx-release-nginx-ingress 80:80 
