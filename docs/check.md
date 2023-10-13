# Table of Contents

* [Initial Setup](setup.md)
* [Topology Creation](topology.md)
* [Data Harvest](dataharvest.md)
* [Pipeline Deployment](pipeline.md)
* [Data Validation](validation.md)
* [Stateful Checks](check.md)
   * [Check File](#check-file)
   * [Schema File](#schema-file)
   * [Configure Netflow (In Progress)](#configure-netflow)
   * [Run Pipeline](#run-pipeline)
* [Telemetry Collection](telemetry.md)

## Stateful Checks

In this excercise, we will use the concept of "test driven development" to create a stateful check as part of our pipeline. Test driven development simply means you write your test before you make your change to your infrastructure. In this training we are working with Elastic to monitor our traffic flows and collect telemetry. Before we configure our network, lets write a test that will check that we have our netflow router configured correctly.

## Check File

Once the validation step completes, your configuration is pushed into the test network and onto the simulated devices. After this occures, the "Check" phase of your pipeline uses PyATS to execute commands on specefic devices. The output of those commands can be compared to additional schemas.

First, we want to enable our netflow check by moving the "check-netflow.yml" file into your mdd-data directory. You can do this by opening your gitlab IDE and selecting rename on the check-netflow.yml file in the schemas/examples directory.

![Screenshot 2023-09-06 at 3 22 51 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/4d1bf539-bdb6-4c4e-a1f2-5c78680cfd43)

This file tells the pipeline to run the following command on your hq_pop router:

```
show flow exporter
```

You want to provide the destination address of your ELK stack host. If you didn't take note of your telemetry host when setting up your environment, you can open your CML prod topology and console into the host to get the IP. 

Here is an example:

```
mdd_tags:
  - hq_pop
mdd_checks:
  - name: Check Netflow Exporter
    command: 'show flow exporter'
    schema: 'pyats/show-flow-exporter.yml.j2'
    method: cli_parse
    check_vars:
      exporter_name: NetFlow-To-Collector
      destination_address: 192.133.185.152
```

## Schema File

Once pyATS runs the commands on the specefied host, it will send the output back. Open up the schema files under schema/pyats to see our expected output.

show-flow-exporter.yml.j2
```
type: object
properties:
  flow_exporter_name:
    type: object
    properties:
      {{ check_vars.exporter_name }}:
        type: object
        properties:
          transport_config:
            type: object
            properties:
              destination_ip_address:
                type: string
                enum: {{ check_vars.destination_address }}
```
In this schema, the output needs to match the format with the variables defined in your check file. 

![Screenshot 2023-09-27 at 12 32 31 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/654fcf8a-05ba-46eb-88df-d59220517608)

Once you commit your change, the pipeline will run and you will see our hq-pop router failed the check because we haven't actually configured our device yet.

![Screenshot 2023-09-27 at 2 49 27 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/076157e5-b1c5-431c-9536-3bb4bb6039a5)

## Configure Netflow
Now that we have our test written to check for an approved netflow configuration, let's create the config file. Navigate to your web IDE and open your mdd-data directory using the same branch created for your check file. Select "Create a new file" and title it "oc-netflow.yml".

![Screenshot 2023-09-27 at 12 36 38 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/ffb36f90-0c62-4914-b937-d7ad5d9eb925)

Copy and paste the following into the configuration file, replacing telemetry IP address with the IP address from your telemetry host:

```
---
mdd_tags:
  - hq_pop
mdd_data:
  mdd:openconfig:
    openconfig-system:system:
      openconfig-system-ext:services:
        openconfig-system-ext:netflow:
          openconfig-system-ext:flow-exporters:
            openconfig-system-ext:flow-exporter:
              - openconfig-system-ext:name: NetFlow-To-Collector
                openconfig-system-ext:config:
                  openconfig-system-ext:name: NetFlow-To-Collector
                  openconfig-system-ext:description: Netflow Collector
                  openconfig-system-ext:collector-address: Telemetry IP address
                  openconfig-system-ext:collector-vrf: Mgmt-intf

```
The "mdd_tags" field at the top of the config denotes that we only want this configuration applied to our HQ Pop router.

## Run Pipeline

Once you implement your changes, commit to your existing branch. You will end up with a successful CI run because our hq-pop router now has the correct netflow configuration applied. 

![Screenshot 2023-09-27 at 2 52 10 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/aa3ef02b-6ae1-42cd-90b4-02694c7eb4ef)





