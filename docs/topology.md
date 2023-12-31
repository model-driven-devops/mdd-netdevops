# Table of Contents

* [Initial Setup](setup.md)
* [Topology Creation](topology.md)
   * [Deploy Production Topology](#deploy-production-topology)
   * [Deploy NSO](#deploy-nso)
   * [Deploy Elastic Stack](#deploy-elastic-stack)
   * [Deploy Test Topology](#deploy-test-topology) (Optional)
* [Data Harvest](dataharvest.md)
* [Pipeline Deployment](pipeline.md)
* [Data Validation](validation.md)
* [Stateful Checks](check.md)
* [Telemetry Collection](telemetry.md)

## Topology Creation
<p align="center">
<img src="https://github.com/model-driven-devops/mdd-base/assets/65776483/02595e8b-188a-47e2-b0a6-893b93ddc502" width="50%" height="50%">
</p>

In this exercise, we will deploy our production environment. The repository contains both an mdd_prod topology file and an mdd_test topology file. Our production topology is fully configured, while our test topology has no configuration on it. For the instructor led classes, the test topology will already be created.

## Deploy Production Topology

Execute the following playbook to launch the topology:
```
ansible-playbook cisco.cml.build -e startup='host' -e wait='yes' -i=inventory_prod
```
This will take a little while since we are booting up each device. Although Cisco Modeling Labs is a simulation platform, it does run the same fully featured software as physical infrastructure. As the topology launches. Explore your inventory_prod directory.

Once your prod environment is set up, you can run the following playbook to see an inventory and get the IP addresses of NSO and Elastic.

```
ansible-playbook cisco.cml.inventory -i inventory_prod
```
![Screenshot 2023-08-25 at 2 56 22 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/479b02e0-15b2-4e38-bbf4-ff7b07f6a6de)

Take note of the IP addresses for NSO and Elastic, so we can access them later in the labs.

## Deploy NSO

For brownfield environments without a consistent API, NSO can be used as our single consistent API gateway into all of our infrastructure. To maintain a single source-of-truth, we use an NSO container for each environment (test and prod). When executing our pipeline, we target the NSO running in the correct environment. 

Install NSO in server mode for prod environment.
```
ansible-playbook ciscops.mdd.nso_install -i inventory_prod
```

Install NSO MDD Packages in prod environment
```
ansible-playbook ciscops.mdd.nso_update_packages -i inventory_prod
```

Add Default auth group to your NSO prod environment
```
ansible-playbook ciscops.mdd.nso_init -i inventory_prod
```

Add devices to prod NSO inventory
```
ansible-playbook ciscops.mdd.nso_update_devices -i inventory_prod
```

## Deploy Elastic Stack

To deploy the telemetry stack, run the telemetry install playbook.
```
ansible-playbook ciscops.mdd.telemetry_install_elastic -i inventory_prod
```
This may take some time, because we are installing docker on the host, deploying containers, and waiting for the stack to come up.
Once the containers are up and running, you will see a report verifying each one is working correctly.

![Screenshot 2023-09-05 at 10 28 07 AM](https://github.com/model-driven-devops/mdd-base/assets/65776483/82814491-3e63-48d6-8e14-f34f7f58e31f)

Once complete, you can navigate to the IP address of your telemetry host using port 5601 to verify elastic came up.

![Screenshot 2023-09-11 at 11 48 52 AM](https://github.com/model-driven-devops/mdd-base/assets/65776483/e2655d34-133d-4efd-b474-addda881796b)


## Deploy Test Topology

Note: If your test environment is already set up, you can proceed to the [Data Harvest](dataharvest.md) section.

### Digital Twin Creation

The digital twin playbook is meant to map a physical environment and auto-generate a topology and interface mapping table that can be imported to CML for CI testing. This playbook will not fully work when mapping an already simulated environment, but it is worth going through the exercise to understand the output.

```
ansible-playbook ciscops.mdd.cml_update_lab -i inventory_prod -e start_from=1 -e inventory_dir=inventory_test -e use_cat9kv=yes
```

If you need to set up your test environment, you have to change your environment variable to target mdd_test in CML and follow the same set of instructions a second time using the inventory_test directory.

```
export CML_LAB=mdd_test
```
Deploy lab

```
ansible-playbook cisco.cml.build -e startup='host' -e wait='yes' -i=inventory_test
```
Deploy NSO
```
ansible-playbook ciscops.mdd.nso_install -i inventory_test
```
```
ansible-playbook ciscops.mdd.nso_update_packages -i inventory_test
```
```
ansible-playbook ciscops.mdd.nso_init -i inventory_test
```
```
ansible-playbook ciscops.mdd.nso_update_devices -i inventory_test
```
We do not need to push a second ELK stack since our testing will be targeted at the network configuration. 

