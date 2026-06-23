module "master" {
  source = "./modules/node-group"

  role             = "master"
  ignition_config  = "master"
  node_count       = var.master_count
  node_name_suffix = local.node_name_suffix
  image_id         = data.xelon_template.rhcos.id
  memory_gib       = var.master_memory_gib
  cpu_cores        = var.master_cpu_cores
  volume_size_gb   = var.default_volume_size_gb
  network_id       = local.subnet_uuid
  ignition_ca      = var.ignition_ca
  api_int          = "api-int.${local.node_name_suffix}"
  cluster_id       = var.cluster_id
  tenant_id        = data.xelon_tenant.tenant.id
}
