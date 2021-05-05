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
  default     = ["1514", "1515", "22"]
}

variable "kibana_tcp_port" {
  description = "[Kibana web port]"
  type        = number
  default     = 5601
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
# Image to region mapping
# ---------------------------------------------------------------------------------------------------------------------
variable "instance_image_ocid" {
  type = map

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-Autonomous-Linux-7.9
    # Oracle-Autonomous-Linux-7.9-2021.01-0
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaadzbjqqwjzgl7yweoiqbltuh2y7kb4alzyuv4k3mambxpcpiicj3a"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaauitscop5dhasbqkegaju56brylkckgi2wfecct2cuvn4xk33d2wq"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaamv56sieig6vgu7jqg5pber3oe6xwrszjvfdbl2veka5dwrdgomea"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaay6ffduwdwuip5phglsoqrbztdxs5kq2qjt3rgqowksoltnxcjdea"
  }
}
