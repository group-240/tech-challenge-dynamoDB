variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "table_name" {
  description = "DynamoDB table name for orders"
  type        = string
  default     = "tech-challenge-orders"
}

variable "payments_table_name" {
  description = "DynamoDB table name for payments"
  type        = string
  default     = "tech-challenge-payments"
}
