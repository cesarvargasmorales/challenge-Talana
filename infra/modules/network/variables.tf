variable "project_id" {
  type = string
}
variable "network_name" {
  type = string
}

variable "routing_mode" {
  type = string
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
  type = bool
}
variable "healthcheck_source_ranges" {
  type = list(string)
}
variable "healthcheck_ports" {
  type = list(string)
}
variable "healthcheck_target_tags" {
  type = list(string)
}
