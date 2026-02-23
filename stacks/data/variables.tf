/*
  variables.tf (stack 03-data)

  O QUE FAZ:
  - Este arquivo declara as "portas de entrada" para as informações da stack.
  - Cada bloco 'variable' permite que o Terraform receba valores do seu arquivo .tfvars.

  POR QUE O ERRO OCORREU:
  - O Terraform não aceita o caractere ";" para separar argumentos na mesma linha.
  - Cada instrução (type, default, description) deve ocupar uma linha exclusiva.
*/

# =========================================================
# Identidade do Projeto
# =========================================================
variable "project_name" {
  type        = string
  description = "Nome base usado para identificar os recursos no console AWS."
}

variable "environment" {
  type        = string
  description = "Define o estágio da infraestrutura (ex: dev, prod)."
}

variable "aws_region" {
  type        = string
  description = "A região física da AWS onde os dados serão armazenados."
  default     = "us-east-1"
}

# =========================================================
# Backend e Remote State (ALINHADO COM WORKFLOW)
# =========================================================
variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 onde estão os states."
}

variable "remote_backend_dynamodb_table" {
  type        = string
  description = "Tabela usada para o lock do state."
  default     = null
}

variable "remote_state_key_networking" {
  type        = string
  description = "Caminho do arquivo de estado da rede."
  default     = "01-networking/terraform.tfstate"
}

variable "remote_state_key_security" {
  type        = string
  description = "Caminho do arquivo de estado da segurança."
  default     = "security/terraform.tfstate"
}

# =========================================================
# PostgreSQL - RDS (AWS Managed)
# =========================================================
variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

# CORREÇÃO: Removidos os ";" e organizados em linhas separadas
variable "allocated_storage_gb" { 
  type    = number
  default = 20 
}

variable "max_allocated_storage_gb" { 
  type    = number
  default = 50 
}

variable "multi_az" { 
  type    = bool
  default = false 
}

variable "backup_retention_days" { 
  type    = number
  default = 7 
}

variable "deletion_protection" { 
  type    = bool
  default = false 
}

variable "skip_final_snapshot" { 
  type    = bool
  default = true 
}

# =========================================================
# Outros
# =========================================================
variable "vpc_cidr" { 
  type    = string
  default = null 
}

variable "tags" { 
  type    = map(string)
  default = {} 
}