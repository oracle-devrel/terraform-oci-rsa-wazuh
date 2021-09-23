# TERRAFORM-OCI-RSA-WAZUH
This Terraform stack deploys a Wazuh cluster to an Oracle Cloud Infrastructure (OCI) tenancy. 
The stack uses the following OCI resources:
- Compute
- Identity and Access Management
- Object Storage
- Networking
- Load Balancer

An existing vcn with a route table, and NAT gateway are required to deploy the stack.

The stack is intended to be used in conjunction with the following ansible playbooks.
- [oci-rsa-ansible-wazuh](PLACEHOLDER)
- [oci-rsa-ansible-wazuh-kibana](PLACEHOLDER)
- [oci-rsa-ansible-wazuh-odfe](PLACEHOLDER)

If these playbooks are not appropriately provided the stack will only provision the instances and not deploy the Wazuh cluster.

## Requirements
- [Terraform]() >= 1.0.6

## Architecture
![Alt text](https://documentation.wazuh.com/current/_images/deployment1.png)

### Compute
The cluster is configured to use: 
- 1 manager Wazuh node
- 2 worker Wazuh nodes
- 3 Open Distro Elasticsearch nodes
- 1 Kibana node

These numbers can be modified to different cluster sizes.

### IAM
This template creates a dynamic group, and an iam policy for object storage access. These are required for Wazuh log backups.

### Object Storage
Used to store the backup logs for Wazuh.

### Load Balancer
Used by this stack to distribute agent traffic between the master and worker nodes. Internally accessible by the agents 
through domain name `wazuh-lb.wazuh-cluster.local`.

### Networking
The Terraform stack provisions a subnet with 3 security lists for Wazuh, Kibana, Open Distro for Elasticsearch, and 
Elasticsearch API. It also creates a dns zone and records for cluster nodes.

## Branches
* `main` branch contains the latest code.
Terraform stack consists of a Wazuh, ElasticSearch and Kibana nodes. 

## Prerequisites
Before you can run terraform, the required ansible playbooks should be bundled up with the dependancies and uploaded to 
an object storage bucket.

For each of the ansible playbooks, run the following commands.

Assuming you have cloned the repository and are in the repository root:

Command to install the ansible roles
```
ansible-galaxy install -r requirements.yml -p ./.galaxy-roles
```
Command to bundle up the playbook.
Here the `playbook_zip` is `target_dir/playbook_name`
```
tar -czf $playbook_zip $playbook_name
```
Command to upload the tar file to object storage
```
oci os object put -ns $namespace -bn $bucketname --file $playbook_zip --name ${playbook_name}.tgz
```
After Terraform provisions the instance, the bootstrapping script pulls the appropriate tar file from object store and runs the playbook.

## Usage
If the bootstrapping variables are not set, Terraform will only provision the resources and not install the wazuh cluster through ansible. 

### Bootstrapping Variables
Define the following variables in order to deploy the Ansible playbooks during bootstrapping. The default value of these variables is `UNDEFINED`.

- `bootstrap_bucket`: Object storage bucket containing all the Ansible playbooks. For example `my_bootstrap_bucket`
- `wazuh_bootstrap_bundle`:  The tgz containing the Ansible playbook for wazuh manager and workers instances. For example `oci-rsa-ansible-wazuh.tgz`
- `elastic_bootstrap_bundle`: The tgz containing the Ansible playbook for elasticsearch instances. For example `oci-rsa-ansible-wazuh-odfe.tgz`
- `kibana_bootstrap_bundle`:  The tgz containing the Ansible playbook for kibana instance. For example `oci-rsa-ansible-wazuh-kibana.tgz`

### Terraform Variables
Terraform variables used in this stack are referenced [here](VARIABLES.md). These variables are automatically generated 
using the following command:

```
terraform-docs markdown table .
```

### Running Terraform
You need to apply the target of `oci_core_instance.wazuh_workers` before you can apply the rest of the stack.

```
terraform apply -target oci_core_instance.wazuh_workers
terraform apply
```

### How to retrieve sensitive output value
Using following command to retrieve sensitive output value:
```
terraform output -raw <output_variable_name>
```
e.g.
```
terraform output -raw wazuh_password
terraform output -raw opendistro_kibana_password 
```

## Documentation

* [Wazuh Ansible documentation](https://documentation.wazuh.com/current/deploying-with-ansible/index.html)
* [Full documentation](http://documentation.wazuh.com)

## The Team
This repository was developed by the Oracle OCI Regulatory Solutions and Automation (RSA) team. 

## How to Contribute
Interested in contributing?  See our contribution [guidelines](CONTRIBUTE.md) for details.

## License
This repository and its contents are licensed under [UPL 1.0](https://opensource.org/licenses/UPL).