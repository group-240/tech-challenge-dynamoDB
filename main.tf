# ------------------------------------------------------------------
# Arquivo: main.tf
# Descrição: Ponto de entrada principal do Terraform para DynamoDB.
# ------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "fiap-tech-challenge-tfstate-bucket"
    key            = "dynamodb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = "fiap-tech-challenge-tfstate-bucket"
    key    = "core/terraform.tfstate"
    region = var.aws_region
  }
}

# DynamoDB Table
resource "aws_dynamodb_table" "main" {
  name           = var.dynamodb_table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key != "" ? [1] : []
    content {
      name = var.range_key
      type = var.range_key_type
    }
  }

  tags = {
    Name    = "${var.project_name}-dynamodb"
    Project = var.project_name
  }
}

# Outputs
output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.main.arn
}