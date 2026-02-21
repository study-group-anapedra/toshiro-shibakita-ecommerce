/*
  variables.tf (03-data/rds)

  Objetivo:
  - Declarar todas as entradas do “módulo interno” de RDS desta stack.

  Por que isso é importante?
  - Mantém o main.tf limpo.
  - Facilita reuso e evolução (ex.: Multi-AZ, KMS, parâmetros, etc).
  - Permite dev/prod sem alterar código (somente tfvars).
*/

# ----------------------------
# Identidade e ambiente
# ----------------------------
variable "project_name" {
  description = "Nome base do projeto (padronização e tags)."
  type        = string
}

variable "environment" {
  description = "Ambiente (dev/staging/prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

# ----------------------------
# Rede e segurança (vem das stacks 01/02 via remote_state)
# ----------------------------
variable "vpc_id" {
  description = "VPC onde o RDS será criado."
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets privadas para o DB Subnet Group."
  type        = list(string)
}

variable "database_security_group_id" {
  description = "Security Group do banco (controla quem entra na porta 5432)."
  type        = string
}

# ----------------------------
# PostgreSQL (config)
# ----------------------------
variable "db_name" {
  description = "Nome do database inicial."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário master do banco (NÃO colocar senha aqui)."
  type        = string
  default     = "app"
}

variable "db_password" {
  description = "Senha master do banco. Ideal: vir de pipeline/secret manager."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância (dev geralmente micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
  description = "Storage inicial em GB."
  type        = number
  default     = 20
}

variable "max_allocated_storage_gb" {
  description = "Autoscaling de storage (0 desliga)."
  type        = number
  default     = 50
}

variable "multi_az" {
  description = "Alta disponibilidade (prod geralmente true)."
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Retenção de backup (prod maior, dev menor)."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Protege contra delete acidental (prod true)."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Se true, deleta sem snapshot final (dev ok, prod geralmente false)."
  type        = bool
  default     = true
}

# ----------------------------
# Tags
# ----------------------------
variable "tags" {
  description = "Tags extras opcionais."
  type        = map(string)
  default     = {}
}
