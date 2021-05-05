# ---------------------------------------------------------------------------------------------------------------------
# Kibana server and ElasticSearch cluster
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_core_instance" "kibana" {
  compartment_id                      = var.compartment_ocid
  availability_domain                 = random_shuffle.kibana_ad.result[0]
  shape                               = var.kibana_instance_shape
  is_pv_encryption_in_transit_enabled = true
  display_name                        = "kibana"

  freeform_tags = {
    "Description" = "Kibana Node",
    "Function"    = "Kibana node for elasticsearch"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.wazuh_subnet.id
    display_name     = "kibana"
    assign_public_ip = false
    hostname_label   = "kibana"
    freeform_tags = {
      "Description" = "Kibana Instance VNIC",
      "Function"    = "VNIC for Kibana instance"
    }
  }

  metadata = {
    ssh_authorized_keys = file (var.ssh_public_key)
    user_data           = base64encode(data.template_file.elastic_bootstrap.rendered)
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "elastic_nodes" {
  count          = var.elastic_node_instance_count
  compartment_id = var.compartment_ocid
  # TODO: Dynamically pick AD so the cluster doesn't all live on the same AD or a hard coded AD
  availability_domain                 = lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index],"name")
  shape                               = var.elastic_instance_shape
  is_pv_encryption_in_transit_enabled = true
  display_name                        = "elastic_node_${count.index}"

  freeform_tags = {
    "Description" = "Elastic node ${count.index}"
    "Function"    = "Elastic node ${count.index}"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.wazuh_subnet.id
    display_name     = "elasticnode${count.index}"
    assign_public_ip = false
    hostname_label   = "elasticnode${count.index}"
    freeform_tags = {
      "Description" = "Elastic Instance VNIC ${count.index}",
      "Function"    = "VNIC for elastic instance ${count.index}"
    }
  }

  metadata = {
    ssh_authorized_keys = file (var.ssh_public_key)
    user_data           = base64encode(data.template_file.elastic_bootstrap.rendered)
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
  }

  timeouts {
    create = "10m"
  }
}

data "template_file" elastic_bootstrap {
  template = file("${path.module}/userdata/bootstrap")

  vars = {
    bootstrap_bucket = var.bootstrap_bucket
    bootstrap_bundle = var.wazuh_bootstrap_bundle
  }
}

resource "random_shuffle" "kibana_ad" {
  input = local.ad_names
  result_count = 1
}