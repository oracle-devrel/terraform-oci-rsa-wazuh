variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}

variable "oci_dg_prefix" {
  type = string
  description = "[OCI RSA] Dynamic group name, used for bucket access"
  default = "oci_rsa_bucket_access"
}

variable "unique_prefix" {
  type = string
  description = "Unique prefix to prevent naming collisions"
}

variable "bucket_suffix" {
  type = string
  description = "Bucket name suffix"
}