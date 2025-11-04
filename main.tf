terraform {
  required_version = ">= 1.5.0"

  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.19"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.mongodb_public_key
  private_key = var.mongodb_private_key
}

resource "mongodbatlas_project" "project" {
  name   = "projeto-terraform-git"
  org_id = var.org_id
}

resource "mongodbatlas_cluster" "cluster" {
  project_id   = mongodbatlas_project.project.id
  name         = "cluster-git-terraform"
  cluster_type = "REPLICASET"
  provider_settings {
    provider_name         = "GCP"
    region_name           = "SOUTH_AMERICA-EAST1"
    instance_size_name    = "M10"
    disk_size_gb          = 10
    backing_provider_name = "GCP"
  }
  replication_specs {
    num_shards = 1
    region_configs {
      region_name     = "SOUTH_AMERICA-EAST1"
      electable_nodes = 3
      priority        = 7
    }
  }
}

resource "mongodbatlas_database_user" "user" {
  project_id         = mongodbatlas_project.project.id
  username           = var.db_user
  password           = var.db_pass
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}

resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.project.id
  ip_address = var.allowed_ip   # Pode ser "0.0.0.0/0" para liberar geral
  comment    = "Acesso irrestrito (não recomendado em produção)"
}

output "connection_string" {
  value = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
}