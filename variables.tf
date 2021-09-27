# ---------------------------------------------------------------------------------------------------------------------
# Required inputs
# ---------------------------------------------------------------------------------------------------------------------
variable "compartment_ocid" {
  type        = string
  description = "OCID for the target compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID for the target tenancy"
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

variable "unique_prefix" {
  type        = string
  description = "Unique Identifier for the Compartment"
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional inputs
# ---------------------------------------------------------------------------------------------------------------------
variable "wazuh_cidr_block" {
  type        = string
  description = "[Wazuh Subnet] CIDR Block - Should be within the VCN range"
  default     = "10.1.0.0/24"
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
  type        = list(number)
  default     = [1514, 1515]
}

variable "wazuh_ingress_ports" {
  description = "Inbound ports used for Wazuh security list"
  type        = list(string)
  default     = ["1514", "1515", "1516", "22", "55000"]
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
  description = "File name for the bootstrap bundle for master or worker."
  default     = "UNDEFINED"
}

variable "elastic_bootstrap_bundle" {
  type        = string
  description = "Playbook name for elastic cluster"
  default     = "UNDEFINED"
}

variable "kibana_bootstrap_bundle" {
  type        = string
  description = "Playbook name for kibana"
  default     = "UNDEFINED"
}

# ---------------------------------------------------------------------------------------------------------------------
# Image setup
# ---------------------------------------------------------------------------------------------------------------------
variable "instance_image_id" {
  description = "Provide an Oracle Autonomous Linux image id for wazuh host."
  type        = string
  default     = "Autonomous"
}

variable "instance_operating_system_version" {
  description = "the version of Oracle Autonomous Linux"
  type        = string
  default     = "7.9"
}

# ---------------------------------------------------------------------------------------------------------------------
# DNS setup
# ---------------------------------------------------------------------------------------------------------------------
variable "dns_zone_name" {
  description = "The name of the wazuh private zone"
  type        = string
  default     = "wazuh-cluster.local"
}

variable "dns_zone_type" {
  description = "The type of zone: primary or secondary"
  type        = string
  default     = "PRIMARY"
}

variable "dns_zone_scope" {
  description = "The scope of zone: private or null"
  type        = string
  default     = "PRIVATE"
}

variable "wazuh_record_items_domain" {
  description = "The fully qualified domain name for the wazuh load balancer"
  type        = string
  default     = "wazuh-lb"
}

variable "wazuh_record_items_rtype" {
  description = "The type of dns record, such as an address record"
  type        = string
  default     = "A"
}

variable "wazuh_record_items_ttl" {
  description = "The time to live in seconds for the wazuh record"
  type        = number
  default     = "60"
}


# Autoscaling Values
variable "wazuh_worker_autoscaling_min" {
  description = "Minimum number of Wazuh worker instances"
  type        = number
  default     = "2"
}

variable "wazuh_worker_autoscaling_initial" {
  description = "Initial number of Wazuh worker instances"
  type        = number
  default     = "2"
}

variable "wazuh_worker_autoscaling_max" {
  description = "Max number of Wazuh worker instances"
  type        = number
  default     = "4"
}