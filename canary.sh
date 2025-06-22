#!/bin/bash

# There are 3 pods from version 1 and 1 from version 2
# The desired pods for the service is 4.
# For the v2 to take 50% of the traffic means that both
# v1 and v2 will have 2 replicas each.

echo "Starting deployment"

while [ "$(kubectl get po -n udacity | grep -c canary-v1)" -ne "$(kubectl get po -n udacity | grep -c canary-v2)" ]; do
  PODS_V1=$(kubectl get po -n udacity | grep -c canary-v1)
  PODS_V2=$(kubectl get po -n udacity | grep -c canary-v2)

  echo "$((PODS_V1 - 1))"
  echo "$((PODS_V2 - 1))"

  kubectl scale deploy canary-v1 --replicas="$((PODS_V1 - 1))"
  kubectl scale deploy canary-v2 --replicas="$((PODS_V2 + 1))"
  
  until kubectl rollout status deployment/canary-v2 -n udacity; do
    echo "Deploying..."
    sleep 1
  done
done

echo "Deployed"
