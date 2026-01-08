# DynamoDB Table for Orders
resource "aws_dynamodb_table" "orders" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"  # On-demand capacity (free tier friendly)
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "status"
    type = "S"
  }

  # GSI para buscar por status
  global_secondary_index {
    name            = "status-index"
    hash_key        = "status"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = var.table_name
  }
}

# DynamoDB Table for Payments (raw JSON storage)
resource "aws_dynamodb_table" "payments" {
  name         = var.payments_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = var.payments_table_name
  }
}

# NOTA: No AWS Academy Learner Lab, não é possível criar IAM policies.
# O acesso ao DynamoDB será feito através do LabRole existente.
