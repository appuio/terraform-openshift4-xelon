output "ip_addresses" {
  value = xelon_device.node[*].networks[*].ipv4_address
}

output "node_names" {
  value = xelon_device.node[*].hostname
}

output "node_ids" {
  value = xelon_device.node[*].id
}
