# Terraform version
terraform 1.0.6

# How to run this module
You need to apply the target of oci_core_instance.wazuh_workers before you can apply the rest of the stack.

```
terraform apply -target oci_core_instance.wazuh_workers
terraform apply
```

