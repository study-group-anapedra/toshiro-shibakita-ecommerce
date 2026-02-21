# variables.tf
# -------------------------------------------------------------------
# Variáveis de entrada do stack 00-bootstrap.
# Permitem parametrizar o backend remoto (S3 + DynamoDB)
# sem hardcode, suportando múltiplos ambientes.
# -------------------------------------------------------------------

# Nome do projeto
variable "project_name" {
  description = "Nome base do projeto (ex: micro-infra-global)"
  type        = string

  validation {
    condition     = length(var.project_name) > 2
    error_message = "O project_name deve ter pelo menos 3 caracteres."
  }
}

# Ambiente (dev, staging, prod)
variable "environment" {
  description = "Ambiente onde a infraestrutura será criada"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O environment deve ser dev, staging ou prod."
  }
}

# Região AWS
variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Profile AWS (usado apenas localmente)
# Em CI/CD via OIDC essa variável não será utilizada
variable "aws_profile" {
  description = "Profile AWS local (não utilizado em CI/CD com OIDC)"
  type        = string
  default     = null
}

# Nome do bucket S3 do Terraform state
variable "remote_backend_bucket_name" {
  description = "Nome do bucket S3 para armazenar o Terraform state"
  type        = string
}

# Nome da tabela DynamoDB para state locking
variable "remote_backend_dynamodb_table" {
  description = "Nome da tabela DynamoDB para lock do Terraform state"
  type        = string
}

# Tags padrão aplicadas aos recursos
variable "tags" {
  description = "Mapa de tags aplicadas aos recursos do bootstrap"
  type        = map(string)
  default     = {}
}

