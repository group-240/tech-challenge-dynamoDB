output "dynamodb_table_name" {
  description = "DynamoDB orders table name"
  value       = aws_dynamodb_table.orders.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB orders table ARN"
  value       = aws_dynamodb_table.orders.arn
}

output "dynamodb_payments_table_name" {
  description = "DynamoDB payments table name"
  value       = aws_dynamodb_table.payments.name
}

output "dynamodb_payments_table_arn" {
  description = "DynamoDB payments table ARN"
  value       = aws_dynamodb_table.payments.arn
}

output "aws_region" {
  description = "AWS Region where DynamoDB is deployed"
  value       = var.aws_region
}
