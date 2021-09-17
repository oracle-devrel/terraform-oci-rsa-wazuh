# OCI-RSA-TF-WAZUH

## Requirements

- [Terraform]() >= 1.0.6

## Dependencies


## Architecture



![Alt text](https://documentation.wazuh.com/current/_images/deployment1.png)


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