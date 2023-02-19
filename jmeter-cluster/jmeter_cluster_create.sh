#!/usr/bin/env bash
#Create multiple Jmeter namespaces on an existing kuberntes cluster

working_dir=`pwd`

echo "checking if kubectl is present"

if ! hash kubectl 2>/dev/null
then
    echo "'kubectl' was not found in PATH"
    echo "Kindly ensure that you can acces an existing kubernetes cluster via kubectl"
    exit
fi

kubectl version --short

echo "Enter the namespace [default]:"
read tenant

if [[ -z $tenant ]]
then
    tenant=default
fi

echo "Using $tenant namespace has been created"
echo

echo "Creating Jmeter slave nodes"
nodes=`kubectl get no | egrep -v "master|NAME" | wc -l`

echo "Number of worker nodes on this cluster is " $nodes

echo "Enter the number of jmeter-slaves [$(($nodes - 1))]:"
read num_slaves

if [[ -z $num_slaves ]]
then
    num_slaves=$(($nodes - 1))
fi
echo "Creating $num_slaves Jmeter slave replicas and service"
echo

sed -i "s~^\([[:blank:]]*\)replicas:.*$~\1replicas: $num_slaves~" $working_dir/jmeter_slaves_deploy.yaml

kubectl apply -n $tenant -f $working_dir/jmeter_slaves_deploy.yaml

kubectl apply -n $tenant -f $working_dir/jmeter_slaves_svc.yaml

echo "Creating Jmeter Master"

kubectl apply -n $tenant -f $working_dir/jmeter_master_configmap.yaml

kubectl apply -n $tenant -f $working_dir/jmeter_master_deploy.yaml

check_master_exist=`kubectl get pod | egrep -v "master|NAME"`
if [[ -n $check_master_exist ]]
then
    kubectl rollout restart deployment jmeter-master
fi

echo "Printout Of the $tenant Objects"
echo
kubectl get -n $tenant all

echo namespace = $tenant > $working_dir/tenant_export
