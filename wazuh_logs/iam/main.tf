resource "random_id" "policy_name" {
  byte_length = 8
}

resource "random_id" "dg_name" {
  byte_length = 8
}

resource "oci_identity_dynamic_group" "rsa_access_dynamic_group" {
  compartment_id = var.tenancy_ocid
  description = "OCI RSA Object Store Access"
  matching_rule = "any {instance.compartment.id = '${var.compartment_ocid}'}"
  name = "${var.oci_dg_prefix}-${random_id.dg_name.id}"
  freeform_tags = {
    "Description" = "Dynamic group for access to RSA bootstrap bucket"
    "Function"    = "Provides access to the RSA bootstrap bucket"
  }
}

resource "oci_identity_policy" "wazuh_log_backups" {
  compartment_id = var.tenancy_ocid
  description = "Wazuh log backups"
  name = "wazuh_log_backups-${random_id.policy_name.id}"
  freeform_tags = {
    "Description" = "Policy for access to Wazuh backup bucket"
    "Function"    = "Provides access for Wazuh host to back up to backup bucket"
  }
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.rsa_access_dynamic_group.name} to manage objects in compartment id ${var.compartment_ocid} where target.bucket.name='${var.unique_prefix}-${var.bucket_suffix}'",
    "Allow service objectstorage-${var.region} to manage object-family in compartment id ${var.compartment_ocid}"
  ]
}

resource "time_sleep" "sleep_for_policy_create" {
  depends_on = [ oci_identity_policy.wazuh_log_backups ]
  create_duration = "30s"
}