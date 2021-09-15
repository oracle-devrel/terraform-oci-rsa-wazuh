# Terraform version
terraform 1.0.6

# How to run this module
You need to apply the target of oci_core_instance.wazuh_workers before you can apply the rest of the stack.

```
terraform apply -target oci_core_instance.wazuh_workers
terraform apply
```

# How to retrieve sensitive output value
Using following command to retrieve sensitive output value:
```
terraform output -raw <output_variable_name>
```
e.g.
```
terraform output -raw wazuh_password
terraform output -raw opendistro_kibana_password 
```


