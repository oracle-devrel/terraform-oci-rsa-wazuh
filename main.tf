# ---------------------------------------------------------------------------------------------------------------------
# Wazuh subnet and security list
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_core_subnet" "wazuh_subnet" {
  cidr_block          = var.wazuh_cidr_block
  display_name        = "WazuhSubnet"
  dns_label           = "wazuhsubnet"
  security_list_ids   = [oci_core_security_list.wazuh_security_list.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = var.vcn_id
  route_table_id      = var.route_table_id

  freeform_tags = {
    "Description" = "Wazuh subnet"
    "Function"    = "Subnet for wazuh resources"
  }
}

resource "oci_core_security_list" "wazuh_security_list" {
  compartment_id      = var.compartment_ocid
  vcn_id              = var.vcn_id
  display_name        = "Wazuh Security List"
  freeform_tags = {
    "Description" = "Wazuh security lists"
    "Function"    = "Ingress and egress rules for wazuh service"
  }

  egress_security_rules {
    destination = var.egress_security_rules_destination
    protocol = var.egress_security_rules_protocol
    stateless = var.egress_security_rules_stateless
    tcp_options {
      max = var.egress_security_rules_tcp_options_destination_port_range_max
      min = var.egress_security_rules_tcp_options_destination_port_range_min
      source_port_range {
        max = var.egress_security_rules_tcp_options_source_port_range_max
        min = var.egress_security_rules_tcp_options_source_port_range_min
      }
    }
  }
  dynamic ingress_security_rules {
    for_each = var.wazuh_ingress_ports 
    content {
      protocol = var.ingress_security_rules_protocol
      source = data.oci_core_vcn.test_vcn.cidr_blocks[0]
      description = var.ingress_security_rules_description
      stateless = var.ingress_security_rules_stateless
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
        source_port_range {
          max = var.ingress_security_rules_tcp_options_source_port_range_max
          min = var.ingress_security_rules_tcp_options_source_port_range_min
        }
      }
    }
  }
}

data "oci_core_vcn" "test_vcn" {
  vcn_id = var.vcn_id
}