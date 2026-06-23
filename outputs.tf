output "node_name_suffix" {
  value = local.node_name_suffix
}

output "network_id" {
  value = local.subnet_uuid
}

output "api_ip" {
  value = xelon_load_balancer.api.external_ipv4_address
}

output "ingress_ip" {
  value = xelon_load_balancer.ingress.external_ipv4_address
}

output "cluster_id" {
  value = var.cluster_id
}

output "ignition_ca" {
  value = var.ignition_ca
}

output "api_int" {
  value = "api-int.${local.node_name_suffix}"
}

output "dns_entries" {
  value = <<EOF

; Add these records in the ${var.base_domain} zone file.
;
; If ${var.base_domain} is a subdomain of one of your zones, you'll need to
; adjust the labels of records below to the form
; '${local.cluster_name}.<subdomain>'.
;

$ORIGIN ${var.cluster_id}.${var.base_domain}.

api         IN A     ${xelon_load_balancer.api.external_ipv4_address}
ingress     IN A     ${xelon_load_balancer.ingress.external_ipv4_address}
api-int     IN A     ${xelon_load_balancer.api.external_ipv4_address}

EOF
}
