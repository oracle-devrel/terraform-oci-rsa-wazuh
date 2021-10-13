## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.36.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ./wazuh_logs/iam | n/a |
| <a name="module_objectstore"></a> [objectstore](#module\_objectstore) | ./wazuh_logs/objectstore | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_instance.elastic_nodes](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_instance.kibana](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_instance.wazuh_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_instance.wazuh_workers](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_security_list.es_api_security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.es_cluster_security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.kibana_security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.wazuh_security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.wazuh_subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_dns_rrset.wazuhlb_dns_record](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/dns_rrset) | resource |
| [oci_dns_zone.wazuh_dns_zone](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/dns_zone) | resource |
| [oci_load_balancer.wazuh_cluster_load_balancer](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer) | resource |
| [oci_load_balancer_backend.wazuh_cluster_master_backends](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend.wazuh_cluster_worker_backends](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend_set.wazuh_cluster_lb_backend_sets](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_listener.wazuh_cluster_lb_listeners](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_listener) | resource |
| [random_password.opendistro_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.opendistro_kibana_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.wazuh_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_shuffle.kibana_ad](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [oci_core_images.autonomous_images](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_vcn) | data source |
| [oci_dns_views.primary_view](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/dns_views) | data source |
| [oci_identity_availability_domains.ad](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [template_file.ad_names](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.elastic_bootstrap](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.kibana_bootstrap](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.wazuh_cluster_bootstrap](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.wazuh_master_bootstrap](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_bucket"></a> [bootstrap\_bucket](#input\_bootstrap\_bucket) | Name of the bucket created during bootstrapping. | `string` | `"UNDEFINED"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | OCID for the target compartment | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The name of the wazuh private zone | `string` | `"wazuh-cluster.local"` | no |
| <a name="input_dns_zone_scope"></a> [dns\_zone\_scope](#input\_dns\_zone\_scope) | The scope of zone: private or null | `string` | `"PRIVATE"` | no |
| <a name="input_dns_zone_type"></a> [dns\_zone\_type](#input\_dns\_zone\_type) | The type of zone: primary or secondary | `string` | `"PRIMARY"` | no |
| <a name="input_egress_security_rules_destination"></a> [egress\_security\_rules\_destination](#input\_egress\_security\_rules\_destination) | [Wazuh Security List] Egress Destination | `string` | `"0.0.0.0/0"` | no |
| <a name="input_egress_security_rules_protocol"></a> [egress\_security\_rules\_protocol](#input\_egress\_security\_rules\_protocol) | [Wazuh Security List] Egress Protocol | `string` | `"6"` | no |
| <a name="input_egress_security_rules_stateless"></a> [egress\_security\_rules\_stateless](#input\_egress\_security\_rules\_stateless) | [Wazuh Security List] Egress Stateless | `bool` | `false` | no |
| <a name="input_egress_security_rules_tcp_options_destination_port_range_max"></a> [egress\_security\_rules\_tcp\_options\_destination\_port\_range\_max](#input\_egress\_security\_rules\_tcp\_options\_destination\_port\_range\_max) | [Wazuh Security List] Egress TCP Destination Port Range Max | `number` | `65535` | no |
| <a name="input_egress_security_rules_tcp_options_destination_port_range_min"></a> [egress\_security\_rules\_tcp\_options\_destination\_port\_range\_min](#input\_egress\_security\_rules\_tcp\_options\_destination\_port\_range\_min) | [Wazuh Security List] Egress TCP Destination Port Range Min | `number` | `1` | no |
| <a name="input_elastic_bootstrap_bundle"></a> [elastic\_bootstrap\_bundle](#input\_elastic\_bootstrap\_bundle) | Playbook name for elastic cluster | `string` | `"UNDEFINED"` | no |
| <a name="input_elastic_instance_shape"></a> [elastic\_instance\_shape](#input\_elastic\_instance\_shape) | [Elastic Instance] Shape | `string` | `"VM.Standard2.2"` | no |
| <a name="input_elastic_node_instance_count"></a> [elastic\_node\_instance\_count](#input\_elastic\_node\_instance\_count) | Number of ElasticSearch nodes | `number` | `3` | no |
| <a name="input_es_api_ingress_security_rules_description"></a> [es\_api\_ingress\_security\_rules\_description](#input\_es\_api\_ingress\_security\_rules\_description) | [ES API Security List] Description | `string` | `"ES API Security List - Ingress"` | no |
| <a name="input_es_api_ingress_security_rules_protocol"></a> [es\_api\_ingress\_security\_rules\_protocol](#input\_es\_api\_ingress\_security\_rules\_protocol) | [ES API Security List] Ingress Protocol | `string` | `"6"` | no |
| <a name="input_es_api_ingress_security_rules_stateless"></a> [es\_api\_ingress\_security\_rules\_stateless](#input\_es\_api\_ingress\_security\_rules\_stateless) | [ES API Security List] | `bool` | `false` | no |
| <a name="input_es_api_tcp_port"></a> [es\_api\_tcp\_port](#input\_es\_api\_tcp\_port) | [ES web port] | `number` | `9200` | no |
| <a name="input_es_cluster_ingress_security_rules_description"></a> [es\_cluster\_ingress\_security\_rules\_description](#input\_es\_cluster\_ingress\_security\_rules\_description) | [ES Cluster Security List] Description | `string` | `"ES Cluster Security List - Ingress"` | no |
| <a name="input_es_cluster_ingress_security_rules_protocol"></a> [es\_cluster\_ingress\_security\_rules\_protocol](#input\_es\_cluster\_ingress\_security\_rules\_protocol) | [ES Cluster Security List] Ingress Protocol | `string` | `"6"` | no |
| <a name="input_es_cluster_ingress_security_rules_stateless"></a> [es\_cluster\_ingress\_security\_rules\_stateless](#input\_es\_cluster\_ingress\_security\_rules\_stateless) | [ES Cluster Security List] | `bool` | `false` | no |
| <a name="input_es_cluster_tcp_range_max"></a> [es\_cluster\_tcp\_range\_max](#input\_es\_cluster\_tcp\_range\_max) | [ES cluster range max] | `number` | `9400` | no |
| <a name="input_es_cluster_tcp_range_min"></a> [es\_cluster\_tcp\_range\_min](#input\_es\_cluster\_tcp\_range\_min) | [ES cluster range min] | `number` | `9300` | no |
| <a name="input_instance_image_id"></a> [instance\_image\_id](#input\_instance\_image\_id) | Provide an Oracle Autonomous Linux image id for wazuh host. | `string` | `"Autonomous"` | no |
| <a name="input_instance_operating_system_version"></a> [instance\_operating\_system\_version](#input\_instance\_operating\_system\_version) | the version of Oracle Autonomous Linux | `string` | `"7.9"` | no |
| <a name="input_kibana_bootstrap_bundle"></a> [kibana\_bootstrap\_bundle](#input\_kibana\_bootstrap\_bundle) | Playbook name for kibana | `string` | `"UNDEFINED"` | no |
| <a name="input_kibana_ingress_security_rules_description"></a> [kibana\_ingress\_security\_rules\_description](#input\_kibana\_ingress\_security\_rules\_description) | [Kibana Security List] Description | `string` | `"Kibana Security List - Ingress"` | no |
| <a name="input_kibana_ingress_security_rules_protocol"></a> [kibana\_ingress\_security\_rules\_protocol](#input\_kibana\_ingress\_security\_rules\_protocol) | [Kibana Security List] Ingress Protocol | `string` | `"6"` | no |
| <a name="input_kibana_ingress_security_rules_stateless"></a> [kibana\_ingress\_security\_rules\_stateless](#input\_kibana\_ingress\_security\_rules\_stateless) | [Kibana Security List] | `bool` | `false` | no |
| <a name="input_kibana_instance_shape"></a> [kibana\_instance\_shape](#input\_kibana\_instance\_shape) | [Kibana Instance] Shape | `string` | `"VM.Standard2.2"` | no |
| <a name="input_kibana_tcp_port"></a> [kibana\_tcp\_port](#input\_kibana\_tcp\_port) | [Kibana web port] | `number` | `5601` | no |
| <a name="input_region"></a> [region](#input\_region) | Region to deploy wazuh host | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | Default route table for Wazuh subnet | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Path to file containing SSH public key (used for accessing the host) | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID for the target tenancy | `string` | n/a | yes |
| <a name="input_unique_prefix"></a> [unique\_prefix](#input\_unique\_prefix) | Unique Identifier for the Compartment | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID for the target VCN | `string` | n/a | yes |
| <a name="input_wazuh_bootstrap_bundle"></a> [wazuh\_bootstrap\_bundle](#input\_wazuh\_bootstrap\_bundle) | File name for the bootstrap bundle for master or worker. | `string` | `"UNDEFINED"` | no |
| <a name="input_wazuh_cidr_block"></a> [wazuh\_cidr\_block](#input\_wazuh\_cidr\_block) | [Wazuh Subnet] CIDR Block - Should be within the VCN range | `string` | `"10.1.0.0/24"` | no |
| <a name="input_wazuh_cluster_lb_ports"></a> [wazuh\_cluster\_lb\_ports](#input\_wazuh\_cluster\_lb\_ports) | Wazuh inbound ports for the load balancer | `list(string)` | <pre>[<br>  "1514",<br>  "1515"<br>]</pre> | no |
| <a name="input_wazuh_ingress_ports"></a> [wazuh\_ingress\_ports](#input\_wazuh\_ingress\_ports) | Inbound ports used for Wazuh security list | `list(string)` | <pre>[<br>  "1514",<br>  "1515",<br>  "1516",<br>  "22",<br>  "55000"<br>]</pre> | no |
| <a name="input_wazuh_ingress_security_rules_description"></a> [wazuh\_ingress\_security\_rules\_description](#input\_wazuh\_ingress\_security\_rules\_description) | [Wazuh Security List] Description | `string` | `"Wazuh Security List - Ingress"` | no |
| <a name="input_wazuh_ingress_security_rules_protocol"></a> [wazuh\_ingress\_security\_rules\_protocol](#input\_wazuh\_ingress\_security\_rules\_protocol) | [Wazuh Security List] Ingress Protocol | `string` | `"6"` | no |
| <a name="input_wazuh_ingress_security_rules_stateless"></a> [wazuh\_ingress\_security\_rules\_stateless](#input\_wazuh\_ingress\_security\_rules\_stateless) | [Wazuh Security List] | `bool` | `false` | no |
| <a name="input_wazuh_master_instance_shape"></a> [wazuh\_master\_instance\_shape](#input\_wazuh\_master\_instance\_shape) | [Wazuh Master Instance] Shape | `string` | `"VM.Standard2.2"` | no |
| <a name="input_wazuh_record_items_domain"></a> [wazuh\_record\_items\_domain](#input\_wazuh\_record\_items\_domain) | The fully qualified domain name for the wazuh load balancer | `string` | `"wazuh-lb"` | no |
| <a name="input_wazuh_record_items_rtype"></a> [wazuh\_record\_items\_rtype](#input\_wazuh\_record\_items\_rtype) | The type of dns record, such as an address record | `string` | `"A"` | no |
| <a name="input_wazuh_record_items_ttl"></a> [wazuh\_record\_items\_ttl](#input\_wazuh\_record\_items\_ttl) | The time to live in seconds for the wazuh record | `number` | `"60"` | no |
| <a name="input_wazuh_worker_instance_count"></a> [wazuh\_worker\_instance\_count](#input\_wazuh\_worker\_instance\_count) | Number of Wazuh worker nodes | `number` | `2` | no |
| <a name="input_wazuh_worker_instance_shape"></a> [wazuh\_worker\_instance\_shape](#input\_wazuh\_worker\_instance\_shape) | [Wazuh Worker Instance] Shape | `string` | `"VM.Standard2.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_opendistro_admin_password"></a> [opendistro\_admin\_password](#output\_opendistro\_admin\_password) | n/a |
| <a name="output_opendistro_kibana_password"></a> [opendistro\_kibana\_password](#output\_opendistro\_kibana\_password) | n/a |
| <a name="output_wazuh_backup_bucket_name"></a> [wazuh\_backup\_bucket\_name](#output\_wazuh\_backup\_bucket\_name) | n/a |
| <a name="output_wazuh_cluster_ip"></a> [wazuh\_cluster\_ip](#output\_wazuh\_cluster\_ip) | --------------------------------------------------------------------------------------------------------------------- Return the Wazuh server IP address --------------------------------------------------------------------------------------------------------------------- |
| <a name="output_wazuh_password"></a> [wazuh\_password](#output\_wazuh\_password) | --------------------------------------------------------------------------------------------------------------------- Return the passwords for ElasticSearch and Wazuh --------------------------------------------------------------------------------------------------------------------- |
| <a name="output_wazuh_subnet_cidr"></a> [wazuh\_subnet\_cidr](#output\_wazuh\_subnet\_cidr) | n/a |
