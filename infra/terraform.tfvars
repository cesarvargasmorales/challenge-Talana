project_id = "marine-guard-482400-k3"
region     = "us-east1"

# Network
network_name = "challenge-vpc"
routing_mode = "REGIONAL"

subnets = {
  "gke-subnet" = {
    region        = "us-east1"
    ip_cidr_range = "10.10.0.0/24"
  }
}

secondary_ranges = {
  "gke-subnet" = [
    { range_name = "pods", ip_cidr_range = "10.20.0.0/16" },
    { range_name = "services", ip_cidr_range = "10.30.0.0/20" }
  ]
}

gke_subnet_key                = "gke-subnet"
pods_secondary_range_name     = "pods"
services_secondary_range_name = "services"

# PSA (Private Services Access)
psa_range_name    = "psa-range"
psa_prefix_length = 24

# GKE
cluster_name            = "challenge-gke"
gke_deletion_protection = false

node_pools = {
  "default" = {
    machine_type = "e2-standard-2"
    min_count    = 1
    max_count    = 2
    disk_size_gb = 30
    disk_type    = "pd-standard"
  }
}

node_oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
node_labels       = {}

# Artifact Registry
ar_repo_id = "apps"
ar_format  = "DOCKER"

# App
k8s_namespace = "app-talana"

# Workload Identity SA
app_gsa_account_id       = "django-app-gsa"
app_gsa_display_name     = "Django App GSA"
k8s_service_account_name = "django-app-ksa"
enable_workload_identity = true

# Cloud SQL
db_instance_name       = "challenge-pg"
db_database_version    = "POSTGRES_15"
db_tier                = "db-custom-1-3840"
db_enable_private_ip   = true
db_enable_public_ip    = false
db_deletion_protection = false
db_backups_enabled     = true
db_name                = "appdb"
db_user_name           = "appuser"
db_password_secret_id  = "challenge-pg-password"
secret_labels = {
  app = "django"
  env = "dev"
}


# Firewall
create_healthcheck_firewall = false
healthcheck_source_ranges   = []
healthcheck_ports           = []
healthcheck_target_tags     = []
