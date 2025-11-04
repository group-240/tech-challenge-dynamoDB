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
  public_key  = "bocgzzeh"
  private_key = "1d376f65-0bd2-47a5-b00f-c5943873aa96"
}

resource "mongodbatlas_project" "project" {
  name   = "projeto-terraform-git"
  org_id = "6909333add5c232d0e778bfa"
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                   = mongodbatlas_project.project.id
  name                         = "cluster-git-terraform"
  provider_name                = "GCP"
  provider_instance_size_name  = "M10"
  provider_region_name         = "SOUTH_AMERICA-EAST1"
  disk_size_gb                 = 10
  auto_scaling_disk_gb_enabled = true
  cluster_type                 = "REPLICASET"
  num_shards                   = 1
  replication_factor           = 3
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
  ip_address = var.allowed_ip   # Pode ser "0.0.0.0" para liberar geral
  comment    = "Acesso irrestrito (não recomendado em produção)"
}

output "connection_string" {
  value = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
}