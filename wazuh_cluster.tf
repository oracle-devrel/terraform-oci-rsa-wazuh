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
    user_data           = base64encode(data.template_file.wazuh_master_bootstrap.rendered)
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

# ---------------------------------------------------------------------------------------------------------------------
# Instance Configuration used for autoscaling
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_core_instance_configuration" "wazuh_worker_configuration" {
  compartment_id = var.compartment_ocid
  display_name   = "wazuh-worker-configuration"
  freeform_tags = {
    "Description" = "Wazuh Worker Instance Configuration",
    "Function"    = "Defines launch details for wazuh worker tier"
  }

  instance_details {
    instance_type = "compute"
      launch_details {
        compartment_id                      = var.compartment_ocid
        shape                               = var.wazuh_worker_instance_shape
        is_pv_encryption_in_transit_enabled = true
        display_name                        = "WazuhWorkerConfiguration"

        freeform_tags = {
          "Description" = "Wazuh Worker Instance"
          "Function"    = "Autoscaled Wazuh Worker"
        }

        create_vnic_details {
          subnet_id        = oci_core_subnet.wazuh_subnet.id
          display_name     = "wazuhworker"
          assign_public_ip = false
          hostname_label   = "wazuhworker"
          freeform_tags = {
            "Description" = "Wazuh Worker Instance VNIC",
            "Function"    = "VNIC for Wazuh instance"
          }
        }

        extended_metadata = {
          ssh_authorized_keys = file (var.ssh_public_key)
          user_data           = base64encode(data.template_file.wazuh_cluster_bootstrap.rendered)
        }

        source_details {
          source_type = "image"
          image_id    = data.oci_core_images.autonomous_images.images.0.id
        }
      }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Autoscaling instance pool
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_core_instance_pool" "wazuh_worker_pool" {
  depends_on = [ oci_load_balancer_backend_set.wazuh_cluster_lb_backend_sets ]
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.wazuh_worker_configuration.id
  size                      = "1"
  state                     = "RUNNING"
  display_name              = "WazuhWorker"
  freeform_tags = {
    "Description" = "Wazuh Worker Pool",
    "Function"    = "Autoscaling pool for Wazuh workers"
  }

  # To allow updates to instance_configuration without a conflict with the pool
  lifecycle {
    create_before_destroy = true
  }

  placement_configurations {
    availability_domain = lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")
    primary_subnet_id   = oci_core_subnet.wazuh_subnet.id
  }

  placement_configurations {
    availability_domain = lookup(data.oci_identity_availability_domains.ad.availability_domains[1],"name")
    primary_subnet_id   = oci_core_subnet.wazuh_subnet.id
  }

  placement_configurations {
    availability_domain = lookup(data.oci_identity_availability_domains.ad.availability_domains[2],"name")
    primary_subnet_id   = oci_core_subnet.wazuh_subnet.id
  }

# One load balancer backend per Wazuh port
  load_balancers {
    backend_set_name = "wazuh-cluster-bes-${var.wazuh_cluster_lb_ports[0]}"
    load_balancer_id = oci_load_balancer.wazuh_cluster_load_balancer.id
    port             = var.wazuh_cluster_lb_ports[0]
    vnic_selection   = "PrimaryVnic"
  }

  load_balancers {
    backend_set_name = "wazuh-cluster-bes-${var.wazuh_cluster_lb_ports[1]}"
    load_balancer_id = oci_load_balancer.wazuh_cluster_load_balancer.id
    port             = var.wazuh_cluster_lb_ports[1]
    vnic_selection   = "PrimaryVnic"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Autoscaling configuration
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_autoscaling_auto_scaling_configuration" "wazuh_worker_autoscaling_configuration" {
  compartment_id       = var.compartment_ocid
  cool_down_in_seconds = 300
  display_name         = "wazuh_worker_autoscaling_config"
  is_enabled           = true
  freeform_tags = {
    "Description" = "Wazuh Worker Autoscaling Configuration",
    "Function"    = "Defines autoscaling policy for wazuh workers"
  }

  policies {
    capacity {
      initial = var.wazuh_worker_autoscaling_initial
      max     = var.wazuh_worker_autoscaling_max
      min     = var.wazuh_worker_autoscaling_min
    }

    display_name = "WazuhWorkerScalingPolicy"
    policy_type  = "threshold"

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = 1
      }

      display_name = "WazuhWorkerScaleOutRule"

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "GT"
          value    = 90
        }
      }
    }

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }

      display_name = "WazuhWorkerScaleInRule"

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "LT"
          value    = 10
        }
      }
    }
  }

  auto_scaling_resources {
    id   = oci_core_instance_pool.wazuh_worker_pool.id
    type = "instancePool"
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

resource "random_password" "wazuh_password" {
  length      = 16
  special     = true
  number      = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 1
}

module "iam" {
  source           = "./wazuh_logs/iam"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  region           = var.region
  unique_prefix    = var.unique_prefix
  bucket_suffix    = "wazuh-backup-bucket"
}

module "objectstore" {
  depends_on       = [ module.iam ]
  source           = "./wazuh_logs/objectstore"
  compartment_ocid = var.compartment_ocid
  unique_prefix    = var.unique_prefix
  bucket_suffix    = "wazuh-backup-bucket"
}