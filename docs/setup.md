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

Navigate to your virutal desktop and login based on the credentials you've been assigned.

## Repository Set-Up

Navigate to gitlab.aws.ciscops.net and login using your pod credentials.
<p align="center">
<img src="https://github.com/model-driven-devops/mdd-netdevops/assets/65776483/a813bc8c-af8d-499b-a20d-695e6122551b" width="50%" height="50%">
</p>

Open visual studio code and clone the repository locally using the link found in gitlab.
```
git clone https://gitlab.aws.ciscops.net/podxx/mdd-netdevops.git
```

Enter your gitlab username and password when prompted.

![Screenshot 2023-10-16 at 3 30 51 PM](https://github.com/model-driven-devops/mdd-netdevops/assets/65776483/7487692a-57ac-45e0-bc53-f1972f65bde7)

Move to the new repo locally, or select "open folder" in VScode and navigate to your mdd-netdevops folder.

## Local Environment Setup

There are multiple dependencies needed to execute the automation in this repository. It is recommended you create a virtual environment to run the workflows without conflict:
<p align="center">
<img src="https://github.com/model-driven-devops/mdd-netdevops/assets/65776483/ef890776-15d2-4166-b75a-bde080c13881" width="50%" height="50%">
</p>

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
Next, we want to set the environment variables for CML and the Elastic stack. The envvars file in your repository should include the correct information. Open it and verify the credentials match your pod number.
```
export CML_HOST=
export CML_USERNAME=
export CML_PASSWORD=
export CML_LAB=podxx-mdd-prod
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
