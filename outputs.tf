# ---------------------------------------------------------------------------------------------------------------------
# Return the Wazuh server IP address
# ---------------------------------------------------------------------------------------------------------------------

# Potentially no longer needed.
#output "wazuh_cluster_ip" {
  #value = oci_load_balancer.wazuh_cluster_load_balancer.ip_address_details[0].ip_address
#}

output "wazuh_subnet_cidr" {
  description = "Inbound CIDR block for Wazuh agent traffic"
  value       = oci_core_subnet.wazuh_subnet.cidr_block
}

output "kibana_frontend_ip" {
  description = "IP address for the Kibana frontend"
  value       = oci_core_instance.kibana.private_ip
}

# ---------------------------------------------------------------------------------------------------------------------
# Return the passwords for ElasticSearch and Wazuh
# ---------------------------------------------------------------------------------------------------------------------

# Potentially no longer needed.
#output "wazuh_password" {
  #value = random_password.wazuh_password.result
  #sensitive = true
#}

# Potentially no longer needed.
#output "opendistro_kibana_password" {
  #value = random_password.opendistro_kibana_password.result
  #sensitive = true
#}

output "kibana_admin_password" {
  description = "The password needed to log into Kibana/Wazuh"
  value       = random_password.opendistro_admin_password.result
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Return Wazuh Backup Bucket
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_backup_bucket_name" {
  description = "Object Storage bucket for Wazuh log archives"
  value       = module.objectstore.wazuh_backup_bucket_name
}