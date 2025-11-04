variable "mongodb_public_key" {
  description = "Chave pública da API Atlas"
  type        = string
}

variable "mongodb_private_key" {
  description = "Chave privada da API Atlas"
  type        = string
  sensitive   = true
}

variable "org_id" {
  description = "ID da Organização Atlas"
  type        = string
}

variable "db_user" {
  description = "Usuário do MongoDB"
  type        = string
}

variable "db_pass" {
  description = "Senha do MongoDB"
  type        = string
  sensitive   = true
}

variable "allowed_ip" {
  description = "IP liberado para acesso"
  type        = string
}