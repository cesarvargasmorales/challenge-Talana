resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range
    services_secondary_range_name = var.services_secondary_range
  }

  # Clave para manejar node pools aparte
  remove_default_node_pool = true
  initial_node_count       = 1

  # Workaround: define node_config para el pool temporal que
  # GKE considera durante la creación del cluster (cuotas SSD_TOTAL_GB)
  node_config {
    disk_size_gb = var.cluster_boot_disk_size_gb
    disk_type    = var.cluster_boot_disk_type
    oauth_scopes = var.node_oauth_scopes
    labels       = var.node_labels
  }

  deletion_protection = var.deletion_protection

  dynamic "workload_identity_config" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      workload_pool = coalesce(var.workload_pool, "${var.project_id}.svc.id.goog")
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "this" {
  for_each = var.node_pools

  project  = var.project_id
  name     = each.key
  location = var.region
  cluster  = google_container_cluster.this.name

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    oauth_scopes = var.node_oauth_scopes

    labels = merge(var.node_labels, { "pool" = each.key })

    dynamic "workload_metadata_config" {
      for_each = var.enable_workload_identity ? [1] : []
      content {
        mode = "GKE_METADATA"
      }
    }
  }
}
