# Because of this, the oci_core_instance.wazuh_workers resource needs to be applied
locals {
  listener_pairs = [
    for pair in setproduct(flatten(oci_core_instance.wazuh_workers[*][*].private_ip), var.wazuh_cluster_lb_ports) : {
      ip_address  = pair[0]
      port_number = pair[1]
    }
  ]
}

resource "oci_core_instance" "wazuh_master" {
  compartment_id                      = var.compartment_ocid
  availability_domain                 = lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")
  shape                               = var.wazuh_master_instance_shape
  is_pv_encryption_in_transit_enabled = true
  display_name                        = "wazuh_master"

  freeform_tags = {
    "Description" = "Wazuh Master"
    "Function"    = "Master Wazuh node in cluster"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.wazuh_subnet.id
    display_name     = "wazuhmasterinstance"
    assign_public_ip = false
    hostname_label   = "wazuhmasterinstance"
    freeform_tags = {
      "Description" = "Wazuh Master Instance VNIC",
      "Function"    = "VNIC for Wazuh Master instance"
    }
  }

  metadata = {
    ssh_authorized_keys = file (var.ssh_public_key)
    user_data           = base64encode(data.template_file.wazuh_cluster_bootstrap.rendered)
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.autonomous_images.images.0.id
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "wazuh_workers" {
  count = var.wazuh_worker_instance_count
  compartment_id                      = var.compartment_ocid
  availability_domain                 = lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")
  shape                               = var.wazuh_worker_instance_shape
  is_pv_encryption_in_transit_enabled = true
  display_name                        = "wazuh_worker_${count.index}"

  freeform_tags = {
    "Description" = "Wazuh Worker ${count.index}"
    "Function"    = "Wazuh node in worker ${count.index}"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.wazuh_subnet.id
    display_name     = "wazuhworkerinstance${count.index}"
    assign_public_ip = false
    hostname_label   = "wazuhworkerinstance${count.index}"
    freeform_tags = {
      "Description" = "Wazuh Worker Instance VNIC ${count.index}",
      "Function"    = "VNIC for Wazuh instance ${count.index}"
    }
  }

  metadata = {
    ssh_authorized_keys = file (var.ssh_public_key)
    user_data           = base64encode(data.template_file.wazuh_cluster_bootstrap.rendered)
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.autonomous_images.images.0.id
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_load_balancer_backend" "wazuh_cluster_master_backends" {
  count            = length(var.wazuh_cluster_lb_ports)
  backendset_name  = "wazuh-cluster-bes-${var.wazuh_cluster_lb_ports[count.index]}"
  load_balancer_id = oci_load_balancer.wazuh_cluster_load_balancer.id
  ip_address       = oci_core_instance.wazuh_master.private_ip
  port             = var.wazuh_cluster_lb_ports[count.index]
  depends_on       = [ oci_load_balancer_backend_set.wazuh_cluster_lb_backend_sets, ]
}

resource "oci_load_balancer_backend" "wazuh_cluster_worker_backends" {
  for_each = {
    for listener in local.listener_pairs : "${listener.ip_address}.${listener.port_number}" => listener
  }
  backendset_name  = "wazuh-cluster-bes-${each.value.port_number}"
  load_balancer_id = oci_load_balancer.wazuh_cluster_load_balancer.id
  ip_address       = each.value.ip_address
  port             = each.value.port_number
  depends_on       = [ oci_load_balancer_backend_set.wazuh_cluster_lb_backend_sets, ]
}

resource "random_password" "wazuh_password" {
  length           = 16
  special          = true
  number           = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 1
}

module "objectstore" {
  source           = "./wazuh_logs/objectstore"
  compartment_ocid = var.compartment_ocid
  unique_prefix    = var.unique_prefix
  bucket_suffix    = "wazuh-backup-bucket"
}

module "iam" {
  source                    = "./wazuh_logs/iam"
  tenancy_ocid              = var.tenancy_ocid
  compartment_ocid          = var.compartment_ocid
  region                    = var.region
  wazuh_backup_bucket_name  = module.objectstore.wazuh_backup_bucket_name
}