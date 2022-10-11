#!/bin/bash

set -x

POD=$(kubectl get pod -o name -n snyk-broker -l app.kubernetes.io/name=snyk-broker)
NS=snyk-broker

kubectl exec -n ${NS} -it ${POD} -- /bin/bash
# kubectl ssh -u root -n ${NS} ${POD} -- /bin/bash
