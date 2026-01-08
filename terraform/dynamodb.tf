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

# IAM Policy para acesso ao DynamoDB (será usado pelos pods do EKS)
resource "aws_iam_policy" "dynamodb_access" {
  name        = "tech-challenge-dynamodb-access"
  description = "Policy for accessing DynamoDB tables"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          aws_dynamodb_table.orders.arn,
          "${aws_dynamodb_table.orders.arn}/index/*",
          aws_dynamodb_table.payments.arn,
          "${aws_dynamodb_table.payments.arn}/index/*"
        ]
      }
    ]
  })
}
