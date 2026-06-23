locals {
  cluster_name          = var.cluster_name != "" ? var.cluster_name : var.cluster_id
  node_name_suffix      = "${local.cluster_name}.${var.base_domain}"
  create_privnet_subnet = var.network_id == "" ? 1 : 0
  subnet_uuid           = var.network_id == "" ? xelon_network.privnet[0].id : var.network_id
  privnet_cidr          = var.privnet_cidr
  gateway_ip            = join(".", concat(slice(split(".", split("/", var.privnet_cidr)[0]), 0, 3), ["1"]))
  worker_volume_size_gb = var.worker_volume_size_gb == 0 ? var.default_volume_size_gb : var.worker_volume_size_gb
}

data "xelon_cloud" "cloud" {
  name = var.xelon_cloud
}

data "xelon_tenant" "tenant" {}

data "xelon_template" "rhcos" {
  name = var.rhcos_template_name
}

resource "xelon_network" "privnet" {
  count         = local.create_privnet_subnet
  cloud_id      = data.xelon_cloud.cloud.id
  name          = "privnet-${var.cluster_id}"
  network_speed = 1000
  type          = "LAN"
  subnet_size   = tonumber(split("/", local.privnet_cidr)[1])
  network       = split("/", local.privnet_cidr)[0]
  dns_primary   = "1.1.1.1"
  dns_secondary = "8.8.8.8"
  gateway       = local.gateway_ip
}

resource "xelon_firewall" "nat_gw" {
  cloud_id              = data.xelon_cloud.cloud.id
  internal_network_id   = local.subnet_uuid
  name                  = "fw-${var.cluster_id}"
  internal_ipv4_address = local.gateway_ip
  tenant_id             = data.xelon_tenant.tenant.id
}
