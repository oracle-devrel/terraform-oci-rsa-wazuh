# OCI-RSA-TF-WAZUH
This terraform stack deploys a Wazuh cluster to an Oracle Cloud Infrastructure (OCI) tenancy. 
The stack uses the following OCI resources:
- Compute
- Identity and Access Management
- Object Storage
- Networking
- Load Balancer

An existing vcn with a route table, and NAT gateway are required to deploy the stack.


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
Includes dynamic group for object storage bucket access.
Policy for wazuh log backup

### Object Storage
Stores the backup logs for wazuh

### Load Balancer
Points to the Wazuh master and worker nodes. Distributes agent traffic between the master and worker nodes. 

### Networking
Creates a subnet with 3 security lists for wazuh, kibana, elasticsearch, and elasticsearch api.
Creates a dns zone and records for cluster nodes.

## Branches
* `main` branch contains the latest code.


## Usage
### Prerequisites
Before you can run terraform, the required ansible playbooks should be bundled up with the dependancies and uploaded to object storage bucket.

For each of the ansible playbooks, run the following commands.

Assuming you have cloned the repository and are in the repository root:

Command to install the ansible roles
```
ansible-galaxy install --ignore-certs -r requirements.yml -p ./.galaxy-roles
```
Command to install the ansible collections
```
ansible-galaxy collection install --ignore-certs -r requirements.yml -p ./.galaxy-collections
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
After terraform provisions the instance, the bootstrapping script pulls the appropriate tar file from object store and runs the playbook

### How to run this module
If the bootstrapping variables are not set, the terraform will only provision the resources and not install the wazuh cluster through ansible. 

#### Bootstrapping Variables
Replace the following variables in order to deploy the Ansible playbooks during bootstrapping. The default value of these variables is `UNDEFINED`.

- `bootstrap_bucket`: object storage bucket containing all the Ansible playbooks
- `wazuh_bootstrap_bundle`: Ansible playbook for wazuh manager and workers instances 
- `elastic_bootstrap_bundle`: Ansible playbook for elasticsearch instances
- `kibana_bootstrap_bundle`: Ansible playbook for kibana instance

#### Running Terraform
You need to apply the target of oci_core_instance.wazuh_workers before you can apply the rest of the stack.

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

## How to Contribute
Interested in contributing?  See our contribution [guidelines](CONTRIBUTE.md) for details.

## License
This repository and its contents are licensed under [UPL 1.0](https://opensource.org/licenses/UPL).