# ---------------------------------------------------------------------------------------------------------------------
# Ingress and egress rules
# ---------------------------------------------------------------------------------------------------------------------
variable "egress_security_rules_destination" {
  type        = string
  description = "[Wazuh Security List] Egress Destination"
  default     = "0.0.0.0/0"
}

variable "egress_security_rules_protocol" {
  type        = string
  description = "[Wazuh Security List] Egress Protocol"
  default     = "6"
}

variable "egress_security_rules_stateless" {
  type        = bool
  description = "[Wazuh Security List] Egress Stateless"
  default     = false
}

variable "egress_security_rules_tcp_options_destination_port_range_max" {
  description = "[Wazuh Security List] Egress TCP Destination Port Range Max"
  default     = 65535
  type        = number
}

variable "egress_security_rules_tcp_options_destination_port_range_min" {
  description = "[Wazuh Security List] Egress TCP Destination Port Range Min"
  default     = 1
  type        = number
}

variable "wazuh_ingress_security_rules_description" {
  description = "[Wazuh Security List] Description"
  default     = "Wazuh Security List - Ingress"
  type        = string
}

variable "wazuh_ingress_security_rules_protocol" {
  description = "[Wazuh Security List] Ingress Protocol"
  default     = "6"
  type        = string
}

variable "wazuh_ingress_security_rules_stateless" {
  description = "[Wazuh Security List]"
  type        = bool
  default     = false
}

variable "kibana_ingress_security_rules_description" {
  description = "[Kibana Security List] Description"
  default     = "Kibana Security List - Ingress"
  type        = string
}

variable "kibana_ingress_security_rules_protocol" {
  description = "[Kibana Security List] Ingress Protocol"
  default     = "6"
  type        = string
}

variable "kibana_ingress_security_rules_stateless" {
  description = "[Wazuh Security List]"
  type        = bool
  default     = false
}