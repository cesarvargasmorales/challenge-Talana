output "public_ip_address" {
  value = try(google_sql_database_instance.this.public_ip_address, null)
}

output "private_ip_address" {
  value = try(google_sql_database_instance.this.private_ip_address, null)
}

output "db_password_secret_name" {
  value = google_secret_manager_secret.db_password.name
}

output "db_password_secret_id" {
  value = google_secret_manager_secret.db_password.id
}
