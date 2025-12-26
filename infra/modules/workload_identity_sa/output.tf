output "gsa_email" {
  value = google_service_account.gsa.email
}

output "workload_identity_member" {
  value = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}
