/*
  variables.tf (stack 03-data)

  O QUE FAZ:
  - Declara as variáveis do root module da stack 03-data.
  - Corrige os erros de "undeclared input variable" do pipeline.
  - Aqui NÃO existe senha de banco: credenciais serão gerenciadas automaticamente pelo RDS/AWS.

  RELEVÂNCIA:
  - Permite que o Terraform aceite os valores vindos do prod.tfvars.
  - Evita interrupções no GitHub Actions por falta de definição de inputs.
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
  description = "Bucket do Terraform state remoto do ambiente"
  type        = string
}

variable "remote_backend_dynamodb_table" {
  description = "Tabela DynamoDB de lock do Terraform state"
  type        = string
  default     = null
}

# =========================================================
# PostgreSQL - Parâmetros do RDS (CORREÇÃO DO ERRO)
# =========================================================
# Estas declarações permitem que o root module aceite e repasse
# os valores para o módulo RDS interno.

variable "db_name" {
  description = "Nome do database inicial"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário master do banco"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  description = "Tipo da instância (ex: db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
  description = "Armazenamento inicial em GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage_gb" {
  description = "Limite de autoscaling de armazenamento"
  type        = number
  default     = 50
}

variable "multi_az" {
  description = "Habilitar Multi-AZ para alta disponibilidade"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Dias de retenção de backup"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Proteção contra deleção acidental"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final ao destruir o banco"
  type        = bool
  default     = true
}

# =========================================================
# Rede e Governança
# =========================================================
variable "vpc_cidr" {
  description = "CIDR da VPC do ambiente"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais para governança e custos"
  type        = map(string)
  default     = {}
}