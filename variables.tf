# ---------------------------------------------------------------------------------------------------------------------
# Required inputs
# ---------------------------------------------------------------------------------------------------------------------
variable "compartment_ocid" {
  type        = string
  description = "OCID for the target compartment"
}

variable "vcn_id" {
  type        = string
  description = "OCID for the target VCN"
}

variable "ssh_public_key" {
  type        = string
  description = "Path to file containing SSH public key (used for accessing the host)"
}

variable "region" {
  type        = string
  description = "Region to deploy wazuh host"
}

variable "route_table_id" {
  type        = string
  description = "Default route table for Wazuh subnet"
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional inputs
# ---------------------------------------------------------------------------------------------------------------------
variable "wazuh_cidr_block" {
  type        = string
  description = "[Wazuh Subnet] CIDR Block - Should be within the VCN range"
  default     = "10.0.2.0/24"
}

variable "wazuh_master_instance_shape" {
  type        = string
  description = "[Wazuh Master Instance] Shape"
  default     = "VM.Standard2.2"
}

variable "wazuh_worker_instance_shape" {
  type        = string
  description = "[Wazuh Worker Instance] Shape"
  default     = "VM.Standard2.2"
}

variable "wazuh_worker_instance_count" {
  type = number
  description = "Number of Wazuh worker nodes"
  default = 2
}

variable "elastic_instance_shape" {
  type        = string
  description = "[Elastic Instance] Shape"
  default     = "VM.Standard2.2"
}

variable "kibana_instance_shape" {
  type        = string
  description = "[Kibana Instance] Shape"
  default     = "VM.Standard2.2"
}

variable "elastic_node_instance_count" {
  type = number
  description = "Number of ElasticSearch nodes"
  default = 3
}

# ---------------------------------------------------------------------------------------------------------------------
# Application ports
# ---------------------------------------------------------------------------------------------------------------------
variable "wazuh_cluster_lb_ports" {
  description = "Wazuh inbound ports for the load balancer"
  type        = list(string)
  default     = ["1514", "1515"]
}

variable "wazuh_ingress_ports" {
  description = "Inbound ports used for Wazuh security list"
  type        = list(string)
  default     = ["1514", "1515", "1516", "22"]
}

variable "kibana_tcp_port" {
  description = "[Kibana web port]"
  type        = number
  default     = 5601
}

variable "es_api_tcp_port" {
  description = "[ES web port]"
  type        = number
  default     = 9200
}

variable "es_cluster_tcp_range_min" {
  description = "[ES cluster range min]"
  type        = number
  default     = 9300
}

variable "es_cluster_tcp_range_max" {
  description = "[ES cluster range max]"
  type        = number
  default     = 9400
}

# ---------------------------------------------------------------------------------------------------------------------
# Bootstrapping setup
# ---------------------------------------------------------------------------------------------------------------------
variable "bootstrap_bucket" {
  type        = string
  description = "Name of the bucket created during bootstrapping."
  default     = "UNDEFINED"
}

variable "wazuh_bootstrap_bundle" {
  type        = string
  description = "File name for the bootstrap bundle."
  default     = "UNDEFINED"
}

variable "playbook_name" {
  type        = string
  description = "Playbook name for wazuh"
  default     = "oci-rsa-ansible-wazuh"
}

# ---------------------------------------------------------------------------------------------------------------------
# Image setup
# ---------------------------------------------------------------------------------------------------------------------
variable "instance_image_id" {
  description = "Provide a custom image id for the bastion host or leave as Autonomous."
  type        = string
  default     = "Autonomous"
}

variable "instance_operating_system_version" {
  description = "In case Autonomous Linux is used, allow specification of Autonomous version"
  type        = string
  default     = "7.9"
}
