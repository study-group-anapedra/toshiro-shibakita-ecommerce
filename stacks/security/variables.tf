/*
  variables.tf (stack security)

  Este arquivo declara as variáveis que a stack security precisa.

  Objetivo:
  - Manter a stack reutilizável (dev/prod)
  - Evitar hardcode
  - Centralizar inputs em tfvars

  Importante:
  - vpc_id NÃO entra aqui como variável,
    porque a VPC vem do remote_state (data.tf) da stack 01-networking.
*/

# ---------------------------------------------------------
# Região AWS
# ---------------------------------------------------------
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados (ex: us-east-1)"
  type        = string
}

# ---------------------------------------------------------
# Identidade do Projeto (nome e ambiente)
# ---------------------------------------------------------
variable "project_name" {
  description = "Nome do projeto (ex: toshiro-ecommerce)"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev|prod) - usado em nomes, tags e paths do state"
  type        = string
}

# ---------------------------------------------------------
# Remote Backend (state S3 + lock DynamoDB)
# ---------------------------------------------------------
variable "remote_backend_bucket_name" {
  description = "Nome do bucket S3 do tfstate (criado na stack 00-bootstrap)"
  type        = string
}

variable "remote_backend_dynamodb_table" {
  description = "Nome da tabela DynamoDB de lock do tfstate (criada na 00-bootstrap)"
  type        = string
}

# ---------------------------------------------------------
# Aplicação (porta que o ALB usa para falar com o app)
# ---------------------------------------------------------
variable "app_port" {
  description = "Porta interna da aplicação (ex: 8080) usada pelo ALB -> apps"
  type        = number
  default     = 8080
}

# ---------------------------------------------------------
# Segurança opcional (KMS base)
# ---------------------------------------------------------
variable "enable_kms" {
  description = "Se true, cria uma chave KMS base (útil para RDS/Secrets futuramente)"
  type        = bool
  default     = true
}

