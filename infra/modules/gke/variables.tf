variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "cluster_name" {
  type = string
}

variable "network_self_link" {
  type = string
}
variable "subnetwork_self_link" {
  type = string
}

variable "pods_secondary_range" {
  type = string
}
variable "services_secondary_range" {
  type = string
}

variable "deletion_protection" {
  type = bool
}

variable "node_pools" {
  type = map(object({
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    disk_type    = string
  }))
}

variable "node_oauth_scopes" {
  type = list(string)
}
variable "node_labels" {
  type = map(string)
}

variable "enable_workload_identity" {
  type = bool
}

variable "workload_pool" {
  type    = string
  default = null
}
variable "cluster_boot_disk_size_gb" {
  type    = number
  default = 30
}

variable "cluster_boot_disk_type" {
  type    = string
  default = "pd-standard"
}
