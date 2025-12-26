module "network" {
  source                      = "./modules/network"
  project_id                  = var.project_id
  network_name                = var.network_name
  subnets                     = var.subnets
  secondary_ranges            = var.secondary_ranges
  create_healthcheck_firewall = var.create_healthcheck_firewall
  healthcheck_source_ranges   = var.healthcheck_source_ranges
  healthcheck_ports           = var.healthcheck_ports
  healthcheck_target_tags     = var.healthcheck_target_tags
  routing_mode                = var.routing_mode
}

module "gke" {
  source                   = "./modules/gke"
  project_id               = var.project_id
  region                   = var.region
  cluster_name             = var.cluster_name
  network_self_link        = module.network.network_self_link
  subnetwork_self_link     = module.network.subnet_self_links[var.gke_subnet_key]
  pods_secondary_range     = var.pods_secondary_range_name
  services_secondary_range = var.services_secondary_range_name
  node_pools               = var.node_pools
  deletion_protection      = var.gke_deletion_protection
  enable_workload_identity = var.enable_workload_identity
  workload_pool            = var.workload_pool
  node_labels              = var.node_labels
  node_oauth_scopes        = var.node_oauth_scopes
}

module "artifact_registry" {
  source     = "./modules/artifact_registry"
  project_id = var.project_id
  region     = var.region
  repo_id    = var.ar_repo_id
  format     = var.ar_format
}

module "psa" {
  source            = "./modules/psa"
  project_id        = var.project_id
  network_self_link = module.network.network_self_link
  range_name        = var.psa_range_name
  prefix_length     = var.psa_prefix_length
}

module "cloudsql" {
  source                       = "./modules/cloudsql"
  project_id                   = var.project_id
  region                       = var.region
  instance_name                = var.db_instance_name
  database_version             = var.db_database_version
  tier                         = var.db_tier
  network_self_link            = module.network.network_self_link
  enable_private_ip            = var.db_enable_private_ip
  enable_public_ip             = var.db_enable_public_ip
  backups_enabled              = var.db_backups_enabled
  deletion_protection          = var.db_deletion_protection
  db_name                      = var.db_name
  db_user_name                 = var.db_user_name
  db_password_secret_id        = var.db_password_secret_id
  db_password_length           = var.db_password_length
  db_password_override_special = var.db_password_override_special
  secret_labels                = var.secret_labels
  psa_connection_id            = module.psa.connection_id
  depends_on = [
    module.psa
  ]
}

module "workload_identity_app" {
  source                   = "./modules/workload_identity_sa"
  project_id               = var.project_id
  gsa_account_id           = var.app_gsa_account_id
  gsa_display_name         = var.app_gsa_display_name
  db_password_secret_id    = module.cloudsql.db_password_secret_id
  k8s_namespace            = var.k8s_namespace
  k8s_service_account_name = var.k8s_service_account_name
  depends_on = [
    module.gke
  ]
}
