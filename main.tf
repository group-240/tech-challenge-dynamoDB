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
  name   = "projeto-terraform"
  org_id = "6909333add5c232d0e778bfa"
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                = mongodbatlas_project.project.id
  name         				= "ClusterFree"
  cluster_type 				= "REPLICASET" # M0 clusters are replica sets
  provider_name 			= "AWS" # M0 clusters are typically AWS
  disk_size_gb 				= 0.5 # M0 clusters have 0.5 GB storage
  instance_size 			= "M0"
  region_name   			= "US_EAST_1"
  replication_factor 		= 3 # M0 clusters are 3-node replica sets
  mongo_db_major_version 	= "8.0" # Specify your desired MongoDB major version
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