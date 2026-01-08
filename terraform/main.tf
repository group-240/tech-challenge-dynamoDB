terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "tech-challenge-tfstate-group240"
    key            = "dynamodb/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
    dynamodb_table = "tech-challenge-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "TechChallenge"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Remote state from infra
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "tech-challenge-tfstate-group240"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}
