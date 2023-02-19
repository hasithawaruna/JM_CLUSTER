#!/usr/bin/env bash

tenant=default
master_pod=$(kubectl get po -n "$tenant" | grep jmeter-master | awk '{print $1}')

## copying results to local
# mkdir results 
# kubectl cp -n "$tenant" "$master_pod":/csv results/
# kubectl cp -n "$tenant" "$master_pod":/report results/
kubectl cp -n "$tenant" "$master_pod":/results.tar.gz results.tar.gz
