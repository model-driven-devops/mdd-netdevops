# Table of Contents

* [Initial Setup](setup.md)
* [Topology Creation](topology.md)
* [Data Harvest](dataharvest.md)
   * [Harvest Data](#harvest-data)
   * [Explore Data](#explore-data)
* [Pipeline Deployment](pipeline.md)
* [Data Validation](validation.md)
* [Stateful Checks](check.md)
* [Telemetry Collection](telemetry.md)

## Harvest Data

Our production and test environment both have NSO running and connected to each device. The next step us generating your source-of-truth by harvesting your production network. You can do this by running the following playbook:
```
ansible-playbook ciscops.mdd.harvest -i=inventory_prod
```
You should start to see the configurations being populated under the mdd-data directory matching the hierarchy defined in your network.yml file.

![Screenshot 2023-06-05 at 4 37 14 PM](https://github.com/lvangink/mdd_base/assets/65776483/e01fbc26-cf02-49c3-8460-39b03f7f28da)

You will see files parsed as both oc-feature.yml and config-remaining.yml. We are regularly adding supported OpenConfig features to the NSO service. While we continue to add support, you will have your data represented as both OpenConfig and Native.

## Explore Data
