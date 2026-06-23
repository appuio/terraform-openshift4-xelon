variable "tenant_id" {
  type        = string
  description = "Xelon tenant ID"
}

variable "role" {
  type        = string
  description = "Role of the nodes to be provisioned"
}

variable "node_count" {
  type        = number
  description = "Number of nodes to provision"
}

variable "node_name_suffix" {
  type        = string
  description = "Suffix to use for node names"
}

variable "network_id" {
  type        = string
  description = "ID of the network in which to create the nodes"
}

variable "memory_gib" {
  type        = number
  description = "Memory size of node in GiB"
  default     = 16
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores per node"
  default     = 4
}

variable "image_id" {
  type        = string
  description = "Image to use for nodes"
}

variable "volume_size_gb" {
  type        = number
  description = "Boot volume size in GBs"
  default     = 100
}

variable "ignition_ca" {
  type        = string
  description = "CA certificate of the ignition API"
}

variable "ignition_config" {
  type        = string
  default     = "worker"
  description = "Name of the ignition config to use for the nodes"
}

variable "api_int" {
  type        = string
  description = "Hostname of the internal API (to be used for the ignition endpoint)"
}

variable "cluster_id" {
  type        = string
  description = "ID of the cluster to which the nodes belong, used for rendering machines and  machine sets"
}
