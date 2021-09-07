# ---------------------------------------------------------------------------------------------------------------------
# Wazuh subnet and security list
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_core_subnet" "wazuh_subnet" {
  cidr_block          = var.wazuh_cidr_block
  display_name        = "WazuhSubnet"
  dns_label           = "wazuhsubnet"
  security_list_ids   = [
    oci_core_security_list.wazuh_security_list.id,
    oci_core_security_list.kibana_security_list.id,
    oci_core_security_list.es_api_security_list.id,
    oci_core_security_list.es_cluster_security_list.id
  ]
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
    }
  }
  dynamic ingress_security_rules {
    for_each = var.wazuh_ingress_ports 
    content {
      protocol = var.wazuh_ingress_security_rules_protocol
      source = data.oci_core_vcn.vcn.cidr_blocks[0]
      description = var.wazuh_ingress_security_rules_description
      stateless = var.wazuh_ingress_security_rules_stateless
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  }
}

resource "oci_core_security_list" "kibana_security_list" {
  compartment_id      = var.compartment_ocid
  vcn_id              = var.vcn_id
  display_name        = "Kibana Security List"
  freeform_tags = {
    "Description" = "Kibana security lists"
    "Function"    = "Ingress rule for kibana web service"
  }

  ingress_security_rules {
    protocol = var.kibana_ingress_security_rules_protocol
    source = data.oci_core_vcn.vcn.cidr_blocks[0]
    description = var.kibana_ingress_security_rules_description
    stateless = var.kibana_ingress_security_rules_stateless
    tcp_options {
      max = var.kibana_tcp_port 
      min = var.kibana_tcp_port
    }
  }
}

resource "oci_core_security_list" "es_cluster_security_list" {
  compartment_id      = var.compartment_ocid
  vcn_id              = var.vcn_id
  display_name        = "ES cluster Security List"
  freeform_tags = {
    "Description" = "ES cluster security lists"
    "Function"    = "Ingress rule for elastic search cluster"
  }

  ingress_security_rules {
    protocol    = var.es_cluster_ingress_security_rules_protocol
    source      = var.wazuh_cidr_block
    description = var.es_cluster_ingress_security_rules_description
    stateless   = var.es_cluster_ingress_security_rules_stateless
    tcp_options {
      min = var.es_cluster_tcp_range_min
      max = var.es_cluster_tcp_range_max
    }
  }
}

resource "oci_core_security_list" "es_api_security_list" {
  compartment_id      = var.compartment_ocid
  vcn_id              = var.vcn_id
  display_name        = "ES API Security List"
  freeform_tags = {
    "Description" = "ES API security lists"
    "Function"    = "Ingress rule for elastic search service API"
  }

  ingress_security_rules {
    protocol    = var.es_api_ingress_security_rules_protocol
    source      = var.wazuh_cidr_block
    description = var.es_api_ingress_security_rules_description
    stateless   = var.es_api_ingress_security_rules_stateless
    tcp_options {
      max = var.es_api_tcp_port 
      min = var.es_api_tcp_port
    }
  }
}

resource "oci_dns_zone" "wazuh_dns_zone" {
  compartment_id = var.compartment_ocid
  name = var.dns_zone_name
  zone_type = var.dns_zone_type
  scope = var.dns_zone_scope
  view_id = data.oci_dns_views.primary_view.views[0].id
}

resource "oci_dns_rrset" "wazuhlb_dns_record" {
  domain = "${var.wazuh_record_items_domain}.${var.dns_zone_name}"
  rtype = var.wazuh_record_items_rtype
  zone_name_or_id = oci_dns_zone.wazuh_dns_zone.id
  compartment_id = var.compartment_ocid

  items {
      domain = "${var.wazuh_record_items_domain}.${var.dns_zone_name}"
      rdata = oci_load_balancer.wazuh_cluster_load_balancer.ip_address_details[0].ip_address
      rtype = var.wazuh_record_items_rtype
      ttl = var.wazuh_record_items_ttl
  }
  scope = var.dns_zone_scope
  view_id = data.oci_dns_views.primary_view.views[0].id
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

# Get a list of availability domains
data "oci_identity_availability_domains" "ad" {
  compartment_id = var.compartment_ocid
}

data "template_file" "ad_names" {
  count    = length(data.oci_identity_availability_domains.ad.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")
}

locals {
  ad_names = data.template_file.ad_names.*.rendered
}