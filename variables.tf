variable "cluster_id" {
  type        = string
  description = "Project Syn ID of the cluster"
}

variable "xelon_cloud" {
  type        = string
  description = "Name of Xelon cloud to use"
}

variable "xelon_token" {
  type        = string
  description = "Token used for authenticating with Xelon"
}

variable "xelon_client_id" {
  type        = string
  description = "Client ID used for authenticating with Xelon"
}

variable "cluster_name" {
  type        = string
  description = "User-facing name of the cluster. If left empty, cluster_id will be used as cluster_name"
  default     = ""
}

variable "ignition_bootstrap" {
  type        = string
  description = "URL of the bootstrap ignition config (only used during installation)"
  default     = ""
}

variable "ignition_ca" {
  type        = string
  description = "CA certificate of the ignition API"
}

variable "base_domain" {
  type        = string
  description = "Base domain of the cluster"
}

variable "network_id" {
  type        = string
  description = "ID of a Xelon network to re-use for the cluster. If left empty, a new network is created."
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "SSH key to add to nodes"
}

variable "privnet_cidr" {
  default     = "172.18.200.0/24"
  description = "CIDR for the private network."
}

variable "bootstrap_count" {
  type    = number
  default = 0
}

variable "master_count" {
  type    = number
  default = 3
}

variable "master_memory_gib" {
  type        = number
  default     = 16
  description = "Memory for master nodes (GiB)"
}
variable "master_cpu_cores" {
  type        = number
  default     = 4
  description = "CPU cores for master nodes"
}

variable "infra_count" {
  type        = number
  default     = 4
  description = "Number of infra nodes"
}

variable "infra_memory_gib" {
  type        = number
  default     = 16
  description = "Memory for infra nodes (GiB)"
}
variable "infra_cpu_cores" {
  type        = number
  default     = 4
  description = "CPU cores for infra nodes"
}

variable "infra_servers" {
  type        = list(string)
  default     = []
  description = "IP addresses of the infra nodes"
}

variable "worker_count" {
  type        = number
  default     = 3
  description = "Number of worker nodes"
}

variable "worker_memory_gib" {
  type        = number
  default     = 16
  description = "Memory for worker nodes (GiB)"
}
variable "worker_cpu_cores" {
  type        = number
  default     = 4
  description = "CPU cores for worker nodes"
}

variable "default_volume_size_gb" {
  type        = number
  description = "Default boot volume size in GBs"
  default     = 20
}

variable "worker_volume_size_gb" {
  type        = number
  description = "Worker boot volume size in GBs"
  default     = 100
}

variable "additional_worker_groups" {
  type    = map(object({ memory_gib = number, cpu_cores = number, count = number, volume_size_gb = optional(number) }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.additional_worker_groups :
      !contains(["worker", "master", "infra"], k) &&
      v.count >= 0 &&
      (v.volume_size_gb != null ? v.volume_size_gb >= 100 : true)
    ])
    // Cannot use any of the nicer string formatting options because
    // error_message validation is dumb, cf.
    // https://github.com/hashicorp/terraform/issues/24123
    error_message = "Your configuration of `additional_worker_groups` violates one of the following constraints:\n * The worker disk size cannot be smaller than 100GB.\n * Additional worker group names cannot be 'worker', 'master', or 'infra'.\n * The worker count cannot be less than 0."
  }
}

variable "rhcos_template_name" {
  type        = string
  description = "Name of the rhcos VM template to use"
}

variable "lb_enable_proxy_protocol" {
  type        = bool
  description = "Enable the PROXY protocol on the loadbalancers. WARNING: Connections will fail until you enable the same on the OpenShift router as well"
  default     = false
}
