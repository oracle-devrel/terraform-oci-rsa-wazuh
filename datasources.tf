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
    playbook_name              = var.elastic_playbook_name
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
    playbook_name              = var.kibana_playbook_name
    ca_key                     = tls_private_key.ca.private_key_pem
    ca_crt                     = tls_self_signed_cert.ca.cert_pem
    opendistro_kibana_password = random_password.opendistro_kibana_password.result
    opendistro_admin_password  = random_password.opendistro_admin_password.result
    wazuh_password             = sha256(random_password.wazuh_password.result)
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Wazuh bootstrap script and variables
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" wazuh_cluster_bootstrap {
  template = file("${path.module}/userdata/bootstrap")

  vars = {
    bootstrap_bucket = var.bootstrap_bucket
    bootstrap_bundle = var.wazuh_bootstrap_bundle
    playbook_name    = var.wazuh_playbook_name
    ca_key           = tls_private_key.ca.private_key_pem
    ca_crt           = tls_self_signed_cert.ca.cert_pem
    wazuh_user            = "wazuh"
    wazuh_password   = sha256(random_password.wazuh_password.result)
    opendistro_admin_password  = random_password.opendistro_admin_password.result
  }
}
