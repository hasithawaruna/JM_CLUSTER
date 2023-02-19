#!/usr/bin/env bash
# Script: stop the jmeter during the execution
working_dir=`pwd`
tenant=default

master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`
kubectl -n $tenant exec -ti $master_pod -- bash -c "/jmeter/apache-jmeter-*/bin/stoptest.sh"
