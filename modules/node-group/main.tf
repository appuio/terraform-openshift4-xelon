resource "random_id" "node" {
  count       = var.node_count
  prefix      = "${var.role}-"
  byte_length = 2
}

resource "xelon_device" "node" {
  lifecycle {
    ignore_changes = [
      hostname
    ]
  }
  count          = var.node_count
  hostname       = "${random_id.node[count.index].hex}.${var.node_name_suffix}"
  display_name   = "${random_id.node[count.index].hex}.${var.node_name_suffix}"
  memory         = var.memory_gib
  cpu_core_count = var.cpu_cores
  disk_size      = 20
  template_id    = var.image_id
  tenant_id      = var.tenant_id
  password       = "unusedPassword1"
  swap_disk_size = 1
  networks = [{
    id = var.network_id
  }]
  user_data = <<-EOF
    {
      "ignition": {
        "version": "3.1.0",
        "config": {
          "merge": [{
            "source": "https://${var.api_int}:22623/config/${var.ignition_config}"
          }]
        },
        "security": {
          "tls": {
            "certificateAuthorities": [{
              "source": "data:text/plain;charset=utf-8;base64,${base64encode(var.ignition_ca)}"
            }]
          }
        }
      },
      "storage": {
        "files": [
          {
            "path": "/etc/hostname",
            "mode": 420,
            "contents": {
              "source": "data:text/plain;charset=utf-8;base64,${base64encode("${random_id.node[count.index].hex}.${var.node_name_suffix}")}"
            }
          }
        ]
      }
    }
    EOF
}
