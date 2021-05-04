# ---------------------------------------------------------------------------------------------------------------------
# Return the Wazuh server IP address
# ---------------------------------------------------------------------------------------------------------------------
output "wazuh_cluster_ip" {
  value = oci_load_balancer.wazuh_cluster_load_balancer.ip_address_details[0].ip_address
}

output "wazuh_subnet_id" {
  value = oci_core_subnet.wazuh_subnet.id
}

output "wazuh_subnet_cidr" {
  value = oci_core_subnet.wazuh_subnet.cidr_block
}