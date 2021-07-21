# ---------------------------------------------------------------------------------------------------------------------
# Return the Wazuh server IP address
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_cluster_ip" {
  value = oci_load_balancer.wazuh_cluster_load_balancer.ip_address_details[0].ip_address
}

output "wazuh_subnet_cidr" {
  value = oci_core_subnet.wazuh_subnet.cidr_block
}

# ---------------------------------------------------------------------------------------------------------------------
# Return the passwords for ElasticSearch and Wazuh
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_password" {
  value = random_password.wazuh_password.result
}

output "opendistro_kibana_password" {
  value = random_password.opendistro_kibana_password.result
}

output "opendistro_admin_password" {
  value = random_password.opendistro_admin_password.result
}
