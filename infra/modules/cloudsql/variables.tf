variable "project_id" {
  type = string
}
variable "region" {
  type = string
}

variable "instance_name" {
  type = string
}
variable "database_version" {
  type = string
}
variable "tier" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "enable_private_ip" {
  type = bool
}
variable "enable_public_ip" {
  type = bool
}

variable "backups_enabled" {
  type = bool
}

variable "db_name" {
  type = string
}
variable "db_user_name" {
  type = string
}

variable "deletion_protection" {
  type = bool
}

# Secret Manager
variable "db_password_secret_id" {
  type = string
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

variable "psa_connection_id" {
  type = string
}
