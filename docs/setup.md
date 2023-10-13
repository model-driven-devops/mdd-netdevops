# Table of Contents

* [Initial Setup](setup.md)
   * [Repository Setup](#repositoory-setup)
   * [Local Environment Setup](#local-environment-setup)
   * [Environment Variables](#environment-variables)
* [Topology Creation](topology.md)
* [Data Harvest](dataharvest.md)
* [Pipeline Deployment](pipeline.md)
* [Data Validation](validation.md)
* [Stateful Checks](check.md)
* [Telemetry Collection](telemetry.md)

## Initial Setup

Notes
* This section assumes users are working locally. The Lab will use a different mechanism for access so environments are consistent.
* In the instructor led course, your environment will already be set up. You can skip to the [Topology Creation](docs/topology.md) section.

## Repository Set-Up

First clone the template locally.
```
git clone https://github.com/model-driven-devops/mdd-base.git -b demo <your-repo-name>
```
Move to the new repo locally.
```
cd <your-repo-name>
```
## Local Environment Setup

There are multiple dependancies needed to execute the automation in this repository. It is recommended you create a virtual environment to run the workflows without conflict:
```
python3 -m venv venv-mdd
. ./venv-mdd/bin/activate
```
Next, install the Python requirements via pip:
```
pip3 install -r requirements.txt
```
Reactivate virtual environment to ensure your shell is using the newly installed ansible.
```
deactivate
```
```
. ./venv-mdd/bin/activate
```
## Environment Variables
The MDD tooling requires several environment variables. The first one required for base execution is:
```
export ANSIBLE_PYTHON_INTERPRETER=${VIRTUAL_ENV}/bin/python
export ANSIBLE_COLLECTIONS_PATH=./
```
Next, we want to set the environment variables for CML and the Elastic stack.
```
export CML_HOST=cml.domain.com
export CML_USERNAME=user
export CML_PASSWORD=password
export CML_LAB=mdd_prod
export CML_VERIFY_CERT=false
export ELASTIC_USER=elastic
export ELASTIC_PASSWORD=changeme
```
### Ansible Collections
Finally, we want to install the ansible collection into our directory.
```
ansible-galaxy collection install -r requirements.yml
```
Once completed, you can [create your topology](topology.md)
