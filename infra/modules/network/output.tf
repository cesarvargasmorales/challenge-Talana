output "network_self_link" {
  value = google_compute_network.this.self_link
}

output "subnet_self_links" {
  value = { for k, s in google_compute_subnetwork.this : k => s.self_link }
}
