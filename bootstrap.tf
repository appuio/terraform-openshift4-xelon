resource "xelon_device" "bootstrap" {
  lifecycle {
    ignore_changes = [
      hostname
    ]
  }
  count          = var.bootstrap_count
  hostname       = "bootstrap.${local.node_name_suffix}"
  disk_size      = 20
  display_name   = "bootstrap.${local.node_name_suffix}"
  memory         = 16
  cpu_core_count = 4
  networks = [{
    id = local.subnet_uuid
  }]
  template_id    = data.xelon_template.rhcos.id
  tenant_id      = data.xelon_tenant.tenant.id
  password       = "unusedPassword1"
  swap_disk_size = 1
  user_data      = <<-EOF
    {
        "ignition": {
            "version": "3.1.0",
            "config": {
                "merge": [
                    {
                        "source": "${var.ignition_bootstrap}"
                    }
                ]
            }
        },
        "storage": {
            "files": [
                {
                    "path": "/etc/hostname",
                    "mode": 420,
                    "contents": {
                    "source": "data:text/plain;charset=utf-8;base64,${base64encode("bootstrap.${local.node_name_suffix}")}"
                    }
                }
            ]
        }
    }
    EOF
}
