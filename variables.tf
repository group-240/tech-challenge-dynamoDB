variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "tech-challenge"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "techchallenge-dynamodb"
}

variable "billing_mode" {
  description = "Modo de cobrança do DynamoDB"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Nome da chave primária (partition key)"
  type        = string
  default     = "id"
}

variable "hash_key_type" {
  description = "Tipo da chave primária (S, N, B)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Nome da chave de ordenação (sort key), se aplicável"
  type        = string
  default     = ""
}

variable "range_key_type" {
  description = "Tipo da chave de ordenação (S, N, B)"
  type        = string
  default     = "S"
}