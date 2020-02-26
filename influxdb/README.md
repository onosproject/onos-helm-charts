## influxdb for µONOS
Influx DB can be used as a TimeSeries database for the storing of performance metrics etc.

It is possible to install it simply using the [InfluxDB Helm Chart] chart
so no chart definition is included here.

If a more complex installation is required in future, then a
custom `values.yaml` file could be created.

To install in to a `micro-onos` namespace use:
```bash
helm -n micro-onos install ran-metrics stable/influxdb \
--set persistence.enabled=false \
--set initScripts.enabled=true \
--set initScripts.scripts.init\\\.iql=\
"CREATE DATABASE ransimulator WITH DURATION 1d REPLICATION 1;"
```

> This turns off Persistence - whenever the pod is retarted the data will be lost
> There are many persistence options with "PV provisioner support"
>
> It creates a Database **ransimulator** with a default retention policy of 24 hours.

## REST API
The REST API is available at port 8086, and can be used to insert, delete and query the DB.

For example to write a value in to the **ransimulator** database defined above, use a command like:
```bash
curl -i -XPOST http://ran-metrics:8086/write?db=ransimulator --data-binary 'hometrics,ue=0004 value=3 1582721852010461628'
```

> This establishes the "hometrics" measurement (table) and the key (column) "ue"
> with a given value "3" for a given timestamp (1582721852010461628). The timestamp
> together with any "key" columns will act like a primary key to this table.

## Influx CLI
The [Influx CLI] can be accessed by connecting to the Pod:
```bash
kubectl exec -i -t --namespace micro-ono$(kubectl get pods --namespace micro-onos -l app=ran-metrics-influxdb -o jsonpath='{.items[0].metadata.name}') influx -- -database ransimulator
```

A new entry can be easily added:
```sql
INSERT hometrics,ue=0004 value=3
```
> This adds to the table and uses the current time as the timestamp.

At the InfluxQL prompt any query can be entered:
```sql
Connected to http://localhost:8086 version 1.7.6
InfluxDB shell version: 1.7.6
Enter an InfluxQL query
> SELECT * FROM hometrics
name: hometrics
time                ue   value
----                --   -----
1582721852010461628 0004 3
1582721859792194735 0005 3
1582721863701212211 0006 3
> 
```

[InfluxDB Helm Chart]: https://github.com/helm/charts/blob/master/stable/influxdb/README.md
[REST API]: https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/
[Influx CLI]: https://docs.influxdata.com/influxdb/v1.7/tools/shell/
