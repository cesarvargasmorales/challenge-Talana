# Common
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

# Network
variable "network_name" {
  type = string
}

variable "routing_mode" {
  type    = string
  default = "REGIONAL"
}

variable "subnets" {
  type = map(object({
    region        = string
    ip_cidr_range = string
  }))
}

variable "secondary_ranges" {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
}

variable "create_healthcheck_firewall" {
  type    = bool
  default = false
}

variable "healthcheck_source_ranges" {
  type    = list(string)
  default = []
}

variable "healthcheck_ports" {
  type    = list(string)
  default = []
}

variable "healthcheck_target_tags" {
  type    = list(string)
  default = []
}

# PSA (Private Services Access)
variable "psa_range_name" {
  type = string
}

variable "psa_prefix_length" {
  type = number
}

# GKE
variable "cluster_name" {
  type = string
}

variable "gke_subnet_key" {
  type = string
}

variable "pods_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
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
  type    = list(string)
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "gke_deletion_protection" {
  type    = bool
  default = false
}

# Workload Identity (cluster)
variable "enable_workload_identity" {
  type    = bool
  default = true
}

variable "workload_pool" {
  type    = string
  default = null
}

# Artifact Registry
variable "ar_repo_id" {
  type = string
}

variable "ar_format" {
  type    = string
  default = "DOCKER"
}

# Cloud SQL (PostgreSQL)
variable "db_instance_name" {
  type = string
}

variable "db_database_version" {
  type = string
}

variable "db_tier" {
  type = string
}

variable "db_enable_private_ip" {
  type    = bool
  default = true
}

variable "db_enable_public_ip" {
  type    = bool
  default = false
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

variable "db_backups_enabled" {
  type    = bool
  default = true
}

variable "db_name" {
  type = string
}

variable "db_user_name" {
  type = string
}

variable "db_password_secret_id" {
  type = string
}

variable "db_require_ssl" {
  type    = bool
  default = true
}

variable "db_password_length" {
  type    = number
  default = 24
}

variable "db_password_override_special" {
  type    = string
  default = "_%@"
}

variable "secret_labels" {
  type    = map(string)
  default = {}
}


# Workload Identity (IAM + binding a un KSA que se crea en deployment)
variable "app_gsa_account_id" {
  type = string
}

variable "app_gsa_display_name" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account_name" {
  type = string
}
