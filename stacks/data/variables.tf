/*
  variables.tf (stack 03-data)

  Este arquivo declara APENAS as variáveis que você precisa digitar ou 
  que vêm do arquivo .tfvars.

  DIDÁTICA:
  - Removemos vpc_id, subnets e security_groups daqui.
  - Por quê? Porque agora o Terraform busca esses IDs sozinhos através do data.tf.
  - Se deixarmos aqui, o Terraform "esquece" a automação e te pergunta no terminal.
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
# Credenciais do RDS
# =========================================================
variable "db_password" {
  description = "Senha master do RDS (SENSITIVE: não aparece nos logs)"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do database inicial no RDS"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário master do RDS"
  type        = string
  default     = "app"
}

variable "db_instance_class" {
  description = "Classe da instância RDS (ex: db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

# =========================================================
# Tags adicionais
# =========================================================
variable "tags" {
  description = "Tags adicionais para governança e custos"
  type        = map(string)
  default     = {}
}