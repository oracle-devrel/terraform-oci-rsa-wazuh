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
The cluster consists of 
- 1 master wazuh node
- 2 worker nodes
- 3 elastic search node
- 1 kibana node.

![Alt text](https://documentation.wazuh.com/current/_images/deployment1.png)

### IAM
Includes dyanmic group for object storage bucket access.
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

### How to run this module
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