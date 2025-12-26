resource "google_compute_global_address" "psa_range" {
  project      = var.project_id
  name         = var.range_name
  address_type = "INTERNAL"
  purpose      = "VPC_PEERING"
  network      = var.network_self_link

  prefix_length = var.prefix_length
}

resource "google_service_networking_connection" "psa" {
  network                 = var.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range.name]
}
