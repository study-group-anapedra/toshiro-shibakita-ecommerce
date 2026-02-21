/*
  variables.tf

  Este arquivo declara todas as variáveis externas usadas neste stack.

  Variáveis permitem:
  - Reutilizar o mesmo código para dev, staging e prod
  - Evitar valores fixos (hardcoded)
  - Tornar a infraestrutura parametrizável e profissional

  Elas serão preenchidas via:
  - arquivo .tfvars
  - ou pipeline CI/CD
*/

variable "project_name" {
  description = "Nome base do projeto para padronização de recursos"
  type        = string

  validation {
    condition     = length(var.project_name) >= 3
    error_message = "project_name deve ter pelo menos 3 caracteres."
  }
}

variable "environment" {
  description = "Ambiente da infraestrutura (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

