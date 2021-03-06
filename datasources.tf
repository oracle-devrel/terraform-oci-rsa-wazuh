# ---------------------------------------------------------------------------------------------------------------------
# Get the image id of Oracle Autonomous Linux
# ---------------------------------------------------------------------------------------------------------------------
data "oci_core_images" "autonomous_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Autonomous Linux"
  operating_system_version = var.instance_operating_system_version
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# ---------------------------------------------------------------------------------------------------------------------
# Elastic bootstrap script and variables
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" elastic_bootstrap {
  template = file("${path.module}/userdata/elastic_bootstrap")

  vars = {
    bootstrap_bucket           = var.bootstrap_bucket
    bootstrap_bundle           = var.elastic_bootstrap_bundle
    playbook_name              = trimsuffix(var.elastic_bootstrap_bundle, ".tgz")
    ca_key                     = tls_private_key.ca.private_key_pem
    ca_crt                     = tls_self_signed_cert.ca.cert_pem
    opendistro_admin_password  = random_password.opendistro_admin_password.result
    opendistro_kibana_password = random_password.opendistro_kibana_password.result
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Kibana bootstrap script and variables
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" kibana_bootstrap {
  template = file("${path.module}/userdata/kibana_bootstrap")

  vars = {
    bootstrap_bucket           = var.bootstrap_bucket
    bootstrap_bundle           = var.kibana_bootstrap_bundle
    playbook_name              = trimsuffix(var.kibana_bootstrap_bundle, ".tgz")
    ca_key                     = tls_private_key.ca.private_key_pem
    ca_crt                     = tls_self_signed_cert.ca.cert_pem
    opendistro_kibana_password = random_password.opendistro_kibana_password.result
    opendistro_admin_password  = random_password.opendistro_admin_password.result
    wazuh_password             = random_password.wazuh_password.result
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Wazuh bootstrap script and variables
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" wazuh_cluster_bootstrap {
  template = file("${path.module}/userdata/wazuh_bootstrap")

  vars = {
    bootstrap_bucket          = var.bootstrap_bucket
    bootstrap_bundle          = var.wazuh_bootstrap_bundle
    playbook_name             = trimsuffix(var.wazuh_bootstrap_bundle, ".tgz")
    ca_key                    = tls_private_key.ca.private_key_pem
    ca_crt                    = tls_self_signed_cert.ca.cert_pem
    wazuh_password            = random_password.wazuh_password.result
    opendistro_admin_password = random_password.opendistro_admin_password.result
    wazuh_backup_bucket_name  = module.objectstore.wazuh_backup_bucket_name
    node_type                 = "worker"
    wazuh_cluster_key         = random_string.wazuh_cluster_key.result
  }
}

data "template_file" wazuh_master_bootstrap {
  template = file("${path.module}/userdata/wazuh_bootstrap")

  vars = {
    bootstrap_bucket          = var.bootstrap_bucket
    bootstrap_bundle          = var.wazuh_bootstrap_bundle
    playbook_name             = trimsuffix(var.wazuh_bootstrap_bundle, ".tgz")
    ca_key                    = tls_private_key.ca.private_key_pem
    ca_crt                    = tls_self_signed_cert.ca.cert_pem
    wazuh_password            = random_password.wazuh_password.result
    opendistro_admin_password = random_password.opendistro_admin_password.result
    wazuh_backup_bucket_name  = module.objectstore.wazuh_backup_bucket_name
    node_type                 = "master"
    wazuh_cluster_key         = random_string.wazuh_cluster_key.result
  }
}

data "oci_dns_views" "primary_view" {
  # Dns view for Primary VCN
  compartment_id = var.compartment_ocid
  scope = "PRIVATE"
}