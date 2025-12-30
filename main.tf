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
  name   = "projeto-terraform-pro-2"
  org_id = var.org_id   # Correto: valor injetado por variável/secret
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                   	= mongodbatlas_project.project.id
  name                         	= "ClusterFree"
  provider_name 			   	= "TENANT"
  backing_provider_name 		= "AWS"
  provider_region_name 			= "US_EAST_1"
  provider_instance_size_name 	= "M0"
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

resource "mongodbatlas_project_ip_access_list" "allow_all" {
  project_id = mongodbatlas_project.project.id
  cidr_block = "0.0.0.0/0"
  comment    = "Liberado para qualquer IP"
}

output "connection_string" {
  value     = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
  sensitive = true
}
