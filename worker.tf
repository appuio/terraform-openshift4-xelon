module "worker" {
  source = "./modules/node-group"

  role             = "worker"
  node_count       = var.worker_count
  node_name_suffix = local.node_name_suffix
  image_id         = data.xelon_template.rhcos.id
  memory_gib       = var.worker_memory_gib
  cpu_cores        = var.worker_cpu_cores
  volume_size_gb   = local.worker_volume_size_gb
  network_id       = local.subnet_uuid
  ignition_ca      = var.ignition_ca
  api_int          = "api-int.${local.node_name_suffix}"
  cluster_id       = var.cluster_id
  tenant_id        = data.xelon_tenant.tenant.id
}

// Additional worker groups.
// Configured from var.additional_worker_groups
module "additional_worker" {
  for_each = var.additional_worker_groups

  source = "./modules/node-group"

  role             = each.key
  node_count       = each.value.count
  node_name_suffix = local.node_name_suffix
  image_id         = data.xelon_template.rhcos.id
  memory_gib       = each.value.memory_gib
  cpu_cores        = each.value.cpu_cores
  volume_size_gb   = each.value.volume_size_gb != null ? each.value.volume_size_gb : local.worker_volume_size_gb
  network_id       = local.subnet_uuid
  ignition_ca      = var.ignition_ca
  api_int          = "api-int.${local.node_name_suffix}"
  cluster_id       = var.cluster_id
  tenant_id        = data.xelon_tenant.tenant.id
}
