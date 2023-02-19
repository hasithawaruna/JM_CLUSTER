# Jmeter Cluster Support for Kubernetes

## Prerequisits
* Kubernetes Cluster
* kubectl access

## Getting started 

* Create jmeter-master, slave, influxdb & grafana
    ```bash
    cd jmeter-cluster
    ./jmeter_cluster_create.sh
    ```

* Start load-test without csv
    ```bash
    ./start_test.sh <JMX_FILE>
    ```

### Start load-test with csv

* To run the load test
    ```bash
    ./start_csv_copy.sh
    ./start_csv_test.sh
    ```

* To copy the results file as `tar.gz`
    ```bash
    ./copy_results.sh
    ```

* To stop the load test during the execution
    ```bash
    ./jmetet_stop.sh
    ```

### Grafana dashboard
* grafana dashboard
    ```
    ./grafana-dashboard/dashboard.sh
    ```
* Add Grafana-reporter link to `http://<Grafana-LB-IP>:8686/api/v5/report/ltaas`

## Reference  
- "Load Testing Jmeter On Kubernetes" medium blog post: https://goo.gl/mkoX9E
- Original Github repo: https://github.com/kubernauts/jmeter-kubernetes
- Grafana-reporter - https://github.com/IzakMarais/reporter
