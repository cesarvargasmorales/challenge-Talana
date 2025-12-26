resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "this" {
  for_each = var.subnets

  project       = var.project_id
  name          = each.key
  region        = each.value.region
  network       = google_compute_network.this.id
  ip_cidr_range = each.value.ip_cidr_range

  dynamic "secondary_ip_range" {
    for_each = lookup(var.secondary_ranges, each.key, [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_firewall" "allow_health_checks" {
  count   = var.create_healthcheck_firewall ? 1 : 0
  project = var.project_id

  name    = "${var.network_name}-allow-healthchecks"
  network = google_compute_network.this.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = var.healthcheck_source_ranges
  allow {
    protocol = "tcp"
    ports    = var.healthcheck_ports
  }

  target_tags = var.healthcheck_target_tags
}
