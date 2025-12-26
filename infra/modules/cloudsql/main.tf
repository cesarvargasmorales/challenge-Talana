resource "random_password" "db" {
  length           = var.db_password_length
  special          = true
  override_special = var.db_password_override_special
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = var.db_password_secret_id

  replication {
    auto {}
  }

  labels = var.secret_labels
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db.result
}

resource "google_sql_database_instance" "this" {
  project             = var.project_id
  name                = var.instance_name
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.enable_private_ip ? var.network_self_link : null
    }

    backup_configuration {
      enabled = var.backups_enabled
    }
  }
  depends_on = [
    var.psa_connection_id
  ]
}

resource "google_sql_database" "db" {
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "user" {
  project  = var.project_id
  instance = google_sql_database_instance.this.name
  name     = var.db_user_name
  password = random_password.db.result

  depends_on = [google_secret_manager_secret_version.db_password]
}
