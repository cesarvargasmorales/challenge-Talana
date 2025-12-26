terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

terraform {
  backend "gcs" {
    bucket = "marine-guard-482400-k3-tfstate"
    prefix = "challenge/infra"
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
}
