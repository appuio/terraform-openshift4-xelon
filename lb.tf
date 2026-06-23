locals {
  master_ips = compact(flatten(concat(module.master.ip_addresses, xelon_device.bootstrap[*].networks[*].ipv4_address)))
  infra_ips  = compact(flatten(module.infra.ip_addresses))
}

resource "xelon_load_balancer" "api" {
  cloud_id   = data.xelon_cloud.cloud.id
  name       = "load-balancer-api-${var.cluster_id}"
  network_id = local.subnet_uuid
  tenant_id  = data.xelon_tenant.tenant.id
  type       = "layer4"
  device_ids = concat(module.master.node_ids, xelon_device.bootstrap[*].id)
}

resource "xelon_load_balancer_forwarding_rule" "api" {
  count            = length(local.master_ips) > 0 ? 1 : 0
  load_balancer_id = xelon_load_balancer.api.id
  from_port        = 6443
  to_port          = 6443
  ipv4_addresses   = local.master_ips
}

resource "xelon_load_balancer" "ingress" {
  cloud_id   = data.xelon_cloud.cloud.id
  name       = "load-balancer-ingress-${var.cluster_id}"
  network_id = local.subnet_uuid
  tenant_id  = data.xelon_tenant.tenant.id
  type       = "layer4"
  device_ids = module.infra.node_ids
}

resource "xelon_load_balancer_forwarding_rule" "ingress-https" {
  count            = length(local.infra_ips) > 0 ? 1 : 0
  load_balancer_id = xelon_load_balancer.ingress.id
  from_port        = 443
  to_port          = 443
  ipv4_addresses   = local.infra_ips
}

resource "xelon_load_balancer_forwarding_rule" "ingress-http" {
  count            = length(local.infra_ips) > 0 ? 1 : 0
  load_balancer_id = xelon_load_balancer.ingress.id
  from_port        = 80
  to_port          = 80
  ipv4_addresses   = local.infra_ips
}
