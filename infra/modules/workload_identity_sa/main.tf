resource "google_service_account" "gsa" {
  project      = var.project_id
  account_id   = var.gsa_account_id
  display_name = var.gsa_display_name
}

# Permiso mínimo para Cloud SQL Auth Proxy / Connector
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# Permitir que un Kubernetes ServiceAccount (KSA) use el GSA vía Workload Identity.
# Nota: este módulo NO crea el KSA; se recomienda crearlo en el repo/folder de deployment.
resource "google_service_account_iam_member" "wi_user" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}

resource "google_secret_manager_secret_iam_member" "db_password_accessor" {
  project   = var.project_id
  secret_id = var.db_password_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.gsa.email}"
}
