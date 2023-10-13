# Table Of Contents

* [Initial Setup](docs/setup.md)
* [Topology Creation](docs/topology.md)
* [Data Harvest](docs/dataharvest.md)
* [Pipeline Deployment](docs/pipeline.md)
* [Data Validation](docs/validation.md)
* [Stateful Checks](docs/check.md)
* [Telemetry Collection](docs/telemetry.md)
   * [Using Kibana]
   * [Building a Dashboard]
   * [Modifying Filebeat]
   * [Modifying Logstash] 

## Telemetry

![Screenshot 2023-09-08 at 5 11 32 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/7652318f-25e0-4038-9112-ea0bfbdf21ab)

Now that our check has passed, we should be streaming netflow into our elastic stack. You'll notice in your topology, you have three hosts connected at each site. When these hosts booted up, they started generating traffic to different websites to simulate a user. When we initially launched the containers into the telemetry host, filebeat generated a series of pre-built dashboards in Kibana.

## Using Kibana

Navigate to your telemetry host IP address with port 5601 - https://ip-address:5601. You can login with the default elastic password we set earlier.

![Screenshot 2023-09-08 at 5 19 13 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/10285af8-ccf9-4cfd-8c15-3630181782c2)

You can select Dashboards from the menu and search for "netflow". Select any of the available dashboards. Below are a few examples of the visualizations available by simply turing on netflow and pointing it to a running instance of Elastic.

![Screenshot 2023-09-08 at 5 21 27 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/579708db-6657-4f47-a51a-ebf323aa8146)
![Screenshot 2023-09-08 at 5 21 56 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/edc776af-612c-4fa5-a309-b48a24e68742)

## Building a Dashboard

## Modifying Filebeat
Navigate back to your virtual desktip and VScode instance. You'll notice in the telemetry folder there are two templates. These templates an be modified and sent to the telemetry node using an ansible playbook.

![Screenshot 2023-09-08 at 5 30 04 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/f63d6ee3-741c-4419-967a-e55e52af823f)

```
filebeat.config.modules:
  enabled: true
  path: ${path.config}/modules.d/*.yml

filebeat.modules:
  - module: netflow
    log:
      enabled: true
      var.netflow_host: "0.0.0.0"
      var.netflow_port: 2055

setup.kibana:
  host: ${KIBANA_HOST}
  username: ${ELASTIC_USER}
  password: ${ELASTIC_PASSWORD}
  dashboards:
    enabled: true

output.elasticsearch:
  hosts: ${ELASTIC_HOSTS}
  username: ${ELASTIC_USER}
  password: ${ELASTIC_PASSWORD}
  ssl.enabled: true
  ssl.certificate_authorities: "certs/ca/ca.crt"
```


### Updating the telemetry node
```
ansible-playbook ciscops.mdd.telemetry_update_elastic -i inventory_prod
```


## Modifying Logstash

