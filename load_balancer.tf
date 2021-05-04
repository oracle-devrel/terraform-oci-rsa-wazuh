# ---------------------------------------------------------------------------------------------------------------------
# Wazuh Cluster load balancer, backend set, and listener
# ---------------------------------------------------------------------------------------------------------------------
resource "oci_load_balancer" "wazuh_cluster_load_balancer" {
  shape          = "400Mbps"
  compartment_id = var.compartment_ocid
  is_private     = true

  freeform_tags = {
    "Description" = "Wazuh Cluster load balancer"
    "Function"    = "Routes traffics to designated hosts"
  }

  subnet_ids = [
    oci_core_subnet.wazuh_subnet.id
  ]

  display_name = "wazuh-cluster-load-balancer"
}

resource "oci_load_balancer_backend_set" "wazuh_cluster_lb_backend_sets" {
  count            = length(var.wazuh_cluster_lb_ports)
  name             = "wazuh-cluster-bes-${var.wazuh_cluster_lb_ports[count.index]}"
  load_balancer_id = oci_load_balancer.wazuh_cluster_load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = var.wazuh_cluster_lb_ports[count.index]
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
    interval_ms         = "10000"
    return_code         = "200"
    timeout_in_millis   = "3000"
    retries             = "3"
  }
}

resource "oci_load_balancer_listener" "wazuh_cluster_lb_listeners" {
  count                    = length(var.wazuh_cluster_lb_ports)
  load_balancer_id         = oci_load_balancer.wazuh_cluster_load_balancer.id
  name                     = "wazuh-tcp-${var.wazuh_cluster_lb_ports[count.index]}"
  default_backend_set_name = "wazuh-cluster-bes-${var.wazuh_cluster_lb_ports[count.index]}"
  port                     = var.wazuh_cluster_lb_ports[count.index]
  protocol                 = "TCP"
  depends_on               = [ oci_load_balancer_backend_set.wazuh_cluster_lb_backend_sets, ]
}