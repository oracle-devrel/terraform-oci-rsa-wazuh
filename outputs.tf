# ---------------------------------------------------------------------------------------------------------------------
# Return the Wazuh server IP address
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_cluster_ip" {
  value = oci_load_balancer.wazuh_cluster_load_balancer.ip_address_details[0].ip_address
}

output "wazuh_subnet_cidr" {
  value = oci_core_subnet.wazuh_subnet.cidr_block
}

output "kibana_frontend_ip" {
  value = oci_core_instance.kibana.private_ip
}

# ---------------------------------------------------------------------------------------------------------------------
# Return the passwords for ElasticSearch and Wazuh
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_password" {
  value = random_password.wazuh_password.result
  sensitive = true
}

output "opendistro_kibana_password" {
  value = random_password.opendistro_kibana_password.result
  sensitive = true
}

output "kibana_admin_password" {
  description = "The password needed to log into Kibana/Wazuh"
  value       = random_password.opendistro_admin_password.result
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Return Wazuh Backup Bucket
# ---------------------------------------------------------------------------------------------------------------------

output "wazuh_backup_bucket_name" {
  value = module.objectstore.wazuh_backup_bucket_name
}