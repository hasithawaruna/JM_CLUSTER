#!/usr/bin/env bash
#Script created to launch Jmeter tests directly from the current terminal without accessing the jmeter master pod.
#It requires that you supply the path to the jmx file
#After execution, test script jmx file may be deleted from the pod itself but not locally.

working_dir="`pwd`"

#Get namesapce variable
tenant=default

jmx="$1"
[ -n "$jmx" ] || read -p 'Enter path to the jmx file ' jmx

if [ ! -f "$jmx" ];
then
    echo "Test script file was not found in PATH"
    echo "Kindly check and input the correct file path"
    exit
fi

# Get Load testing details
echo "Enter the number of threads:"
read num_threads
sed -i "s~^\([[:blank:]]*\)<stringProp name=\"ThreadGroup.num_threads\">.*$~\1<stringProp name=\"ThreadGroup.num_threads\">$num_threads</stringProp>~" ${jmx}

# echo "Enter the ramp_time:"
# read ramp_time
# sed -i "s~^\([[:blank:]]*\)<stringProp name=\"ThreadGroup.ramp_time\">.*$~\1<stringProp name=\"ThreadGroup.ramp_time\">$ramp_time</stringProp>~" ${jmx}

echo "Enter the duration:"
read duration
sed -i "s~^\([[:blank:]]*\)<stringProp name=\"ThreadGroup.duration\">.*$~\1<stringProp name=\"ThreadGroup.duration\">$duration</stringProp>~" ${jmx}


test_name="$(basename "$jmx")"

#Get Master pod details

master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`

kubectl cp "$jmx" -n $tenant "$master_pod:/$test_name"

## Echo Starting Jmeter load test
# kubectl exec -ti -n $tenant $master_pod -- /bin/bash /load_test "$test_name"

# OR to run it on background
kubectl exec -n "$tenant" "$master_pod" -- bash -c "/jmeter/load_test $jmx > /dev/null 2> /dev/null &"
echo "Started the test in container background"

# to check the logs
echo "Streming jmeter logs. To cancel logs [ctrl+c]"
kubectl exec -n "$tenant" "$master_pod" -- tail -f /jmeter.log
