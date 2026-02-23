/*
  variables.tf (stack 03-data)

  O que faz:
  - Declara as variáveis do root module da stack 03-data.
  - Aqui NÃO existe senha de banco: credenciais serão gerenciadas automaticamente pelo RDS/AWS.

  Quem consome:
  - stacks/data/main.tf e stacks/data/data.tf (remote_state)
  - módulos internos (rds, dynamodb, elasticache etc.) via passagem de variáveis

  Relevância:
  - Evita prompts interativos no GitHub Actions.
  - Evita warnings de tfvars com variáveis não declaradas.
*/

# =========================================================
# Identidade do Projeto
# =========================================================
variable "project_name" {
  description = "Nome base do projeto usado para padronizar recursos AWS"
  type        = string
}

variable "environment" {
  description = "Ambiente da infraestrutura (dev, staging ou prod)"
  type        = string
}

# =========================================================
# Região AWS
# =========================================================
variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# =========================================================
# Backend remoto (usado pelos remote_states)
# =========================================================
variable "remote_backend_bucket_name" {
  description = "Bucket do Terraform state remoto do ambiente (ex: *-prod-tfstate)"
  type        = string
}

variable "remote_backend_dynamodb_table" {
  description = "Tabela DynamoDB de lock do Terraform state (se aplicável)"
  type        = string
  default     = null
}

# =========================================================
# Remote State Keys (precisam bater com o workflow/backend key)
# =========================================================
variable "remote_state_key_networking" {
  description = "Key do state da stack networking no S3"
  type        = string
  default     = "prod/networking/terraform.tfstate"
}

variable "remote_state_key_security" {
  description = "Key do state da stack security no S3"
  type        = string
  default     = "prod/security/terraform.tfstate"
}

# =========================================================
# Rede (pode ser usado por módulos / padronização)
# =========================================================
variable "vpc_cidr" {
  description = "CIDR da VPC do ambiente (se aplicável)"
  type        = string
  default     = null
}

# =========================================================
# Tags
# =========================================================
variable "tags" {
  description = "Tags adicionais para governança e custos"
  type        = map(string)
  default     = {}
}