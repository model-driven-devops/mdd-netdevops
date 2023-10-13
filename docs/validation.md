# Table of Contents

* [Initial Setup](setup.md)
* [Topology Creation](topology.md)
* [Data Harvest](dataharvest.md)
* [Pipeline Deployment](pipeline.md)
* [Data Validation](validation.md)
   * [Validation Files](#validation-files)
   * [Schema Files](#schema-files)
   * [Enabling Validation](#enabling-validation)
   * [Remediate Failed Validation](#remediate-failed-validation)
* [Stateful Checks](check.md)
* [Telemetry Collection](telemetry.md)

## Data Validation

The base MDD repository includes pre-built templates for both data validation and stateful check phases of the pipeline. These can be found under the "Schemas" folder. 

The validation phase of the pipeline is a basic data check. Data in your mdd-data directory (source of truth) is compared to schemas that represent what you want your network to look like. These schemas verify confguration changes match or are complient before being applied to any infrastucture. There are two important types of files needed to enable data validation.

* validate-xxxxxx.yml: Any file that starts with the word "validate" inside of your mdd-data directory will be picked up when the pipeline executes. The validate files point to a series of templates to compare data to.
* schemas: Schemas represent the desired configuration of your network. Before any changes are made to your test environment, data must match the schema. This is a quick way to make sure you remain compliant BEFORE any changes are implemented into any environment.

## Validation Files

Validate files start with "validate-xxxx.yml". If any file that starts with "validate" is in your mdd-data directory, the pipeline will take action on it. 

```
---
mdd_tags:
  - all
mdd_schemas:
  - name: banner
    file: 'local/banner.schema.yml'
  - name: dns
    file: 'local/dns.schema.yml.j2'
    validate_vars:
      dns_servers:
        - 208.67.222.222
        - 208.67.220.220
  - name: domain
    file: 'local/domain.schema.yml.j2' 
    validate_vars:
      domain_name: mdd.cisco.com
```
The above example is your validate-system.yml. The mdd_tags variable at the top tells the pipeline to only run the validation against devices in your inventory that include a specific tag. For example, if mdd_tags was set to "routers", it would only run against devices with the tag "routers".

the mdd_schemas variable provides the pipeline with the name and location of the schema that will be used for validation. Simple schemas that are looking for static settings can be written as .yml or .json. If you want to create flexible schemas to check for data that may be more dynamic, you can use Jinja 2 and provide your validate file with the specefic vars you want to check. In the above example, you can see the last schema is checking for a consistent domain name across all devices and its pointing to the "local" folder. 

## Schema files

Below is our domain.schema.yml.j2 file.

```
type: object
properties:
  openconfig-system:system:
    type: object
    properties:
      openconfig-system:config:
        type: object
        properties:
          openconfig-system:domain-name:
            type: string
            enum: {{ validate_vars.domain_name }}
        required:
          - openconfig-system:domain-name
    required:
      - openconfig-system:config
  required:
    - openconfig-system:system
```

This file represents how you want your data to look before being pushed to any device. These validation schemas are extremely flexible and easy to re-purpose. They also follow standard JSON schema logic. This example is checking for the domain name specified in your validate-system.yml file.

## Enabling Validation

To enable validation, you just need to move the validate-system.yml file into your mdd-data directory. We will do this using gitlab. Select the "Web IDE" in gitlab and navigate to your schemas folder. Find the validate-system.yml file under the examples folder. Select "rename/move" and change the file location to "mdd-data" directory.

![21f60813-5940-4789-b781-4b9f6cea8b05](https://github.com/model-driven-devops/mdd-base/assets/65776483/8ab8f452-a624-4a65-b642-437c6e2df056)

Select "Commit" once moved and select "commit new branch". Commiting to a branch will kick off the CI part of the pipeline. You can select the CI/CD option on your sidebar to see the pipeline run. You will eventually see a red x for the second stage of the pipeline indicating the validation phase failed.

![Screenshot 2023-08-21 at 2 17 28 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/0035a740-dfb9-4456-bceb-1f6d4df48669)

## Remediate Failed Validation

If you select the failed validation phase, you can see the generated report that identifies what devices failed.

![3689e6f3-d44c-489b-a4de-73ef7c501372](https://github.com/model-driven-devops/mdd-base/assets/65776483/ad2561b4-2b6c-4628-86e5-60e1eecdcae9)

In this example, you can see we have multiple hosts that do not have the correct domain configured.

In the pipeline run, we can see multiple devices failed the same validation schema. Instead of having to go device by device and modifying each configuration, we want to set this globally and make sure all our devices get the correct domain. To do this, we will create a "oc-system.yml" file at the global level of your directory.

![Screenshot 2023-08-21 at 2 21 10 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/c7cf2a68-9e70-4437-8de8-b6db9f271766)

You can see the directory structure in your web IDE. Configuration settings at the top level will be applied to all devices. However; these configuration settings can be overridden at the device level. This hierarchical structure makes it very easy to operate large networks.

![Screenshot 2023-09-05 at 1 19 41 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/9e6c0142-4ed5-4cf5-acca-50c10b7605d4)

Now that your oc-system file is created, lets look at the configuration of a device that passed validation. 

![Screenshot 2023-08-21 at 2 27 40 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/004e6af9-8c53-44bf-8ce0-e5012f72f548)

You can see the correct domain name configuration here. Copy the correct config and paste it into your global oc-system.yml file. You can remove the unneccesary pieces of configuration. You will end up with a oc-system file that contains the proper config for your domain-name and login-banner. Once you commit this change, any device that does not contain this configuration will adopt it from the global config.

![Screenshot 2023-08-21 at 2 30 48 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/fe3f0e39-9d77-49b3-8f2b-a06a1922f911)

Commit this change to your existing branch.

![Screenshot 2023-08-21 at 2 36 53 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/5e1531a9-4e51-4be3-ade6-41684d984d67)

Congrats! You have completed a sucessful CI pipeline run. Once you see your validation has passed, you can navigate to "Merge Requests" and select "Merge". This will update the main branch and push your domain name changes to your production environment.

![Screenshot 2023-08-21 at 2 38 03 PM](https://github.com/model-driven-devops/mdd-base/assets/65776483/3462f702-3b87-47ac-9b89-dfbbdf4e7002)

Congrats! Now you are validating any configuration changes before they are made to your test network. Now lets add some [Stateful Checks](check.md).
