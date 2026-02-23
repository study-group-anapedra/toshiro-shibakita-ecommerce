/*
  variables.tf (stack 03-data)

  O que faz:
  - Declara as variáveis do ROOT MODULE da stack 03-data.
  - Esta stack consome outputs de networking e security via terraform_remote_state (data.tf).
  - Não existe db_password aqui: a senha do RDS é gerenciada automaticamente pela AWS
    (manage_master_user_password = true no módulo rds).

  Quem "conversa" com este arquivo:
  - env/prod.tfvars (valores do ambiente)
  - stacks/data/data.tf (usa remote_backend_bucket_name + remote_state_key_*)
  - stacks/data/main.tf (passa vars para os módulos rds/elasticache/dynamodb)
*/

# =========================================================
# Identidade do Projeto
# =========================================================
variable "project_name" {
  description = "Nome base do projeto usado para padronizar recursos AWS"
  type        = string

  validation {
    condition     = length(var.project_name) >= 3
    error_message = "project_name deve possuir pelo menos 3 caracteres."
  }
}

variable "environment" {
  description = "Ambiente da infraestrutura (dev, staging ou prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
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
# Backend remoto (Terraform State) - usado no remote_state do data.tf
# =========================================================
variable "remote_backend_bucket_name" {
  description = "Bucket do Terraform state remoto do ambiente (ex: toshiro-ecommerce-prod-tfstate)"
  type        = string
}

variable "remote_backend_dynamodb_table" {
  description = "Tabela DynamoDB de lock do Terraform state (ex: toshiro-ecommerce-prod-tfstate-lock)"
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
# Configs do RDS (inputs do módulo rds via stacks/data/main.tf)
# Observação: user pode existir; senha é AWS-managed.
# =========================================================
variable "db_name" {
  description = "Nome do database inicial no RDS"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário master do RDS (senha gerenciada automaticamente pela AWS)"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  description = "Classe da instância RDS (ex: db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
  description = "Storage inicial (GB) do RDS"
  type        = number
  default     = 20
}

variable "max_allocated_storage_gb" {
  description = "Storage máximo autoscaling (GB) do RDS"
  type        = number
  default     = 50
}

variable "multi_az" {
  description = "Habilita Multi-AZ no RDS"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Dias de retenção de backup automático do RDS"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Proteção contra deleção do RDS"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Se true, não cria snapshot final ao destruir (para labs/dev costuma ser true)"
  type        = bool
  default     = true
}

# =========================================================
# Rede (opcional; pode existir em prod.tfvars sem quebrar)
# =========================================================
variable "vpc_cidr" {
  description = "CIDR da VPC (se você quiser validar/padronizar)."
  type        = string
  default     = null
}

# =========================================================
# Tags adicionais
# =========================================================
variable "tags" {
  description = "Tags adicionais para governança e custos"
  type        = map(string)
  default     = {}
}