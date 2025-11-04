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
  public_key  = "lsinfvms"
  private_key = "366511a3-de6e-4358-9acc-42239760445e"
}

resource "mongodbatlas_project" "project" {
  name   = "projeto-terraform-git"
  org_id = "6909333add5c232d0e778bfa"
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                   = mongodbatlas_project.project.id
  name                         = "cluster-free"
  provider_name                = "AWS"                 # ou "GCP" ou "AZURE" conforme imagem
  provider_instance_size_name  = "M0"                  # M0 é o FREE
  provider_region_name         = "SA_EAST_1"           # Região disponível para M0 (ver observação abaixo)
  cluster_type                 = "REPLICASET"
  auto_scaling_disk_gb_enabled = false                 # M0 não possui autoscaling
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