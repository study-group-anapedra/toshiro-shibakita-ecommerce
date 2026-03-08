/*
  variables.tf (stack 09-governance)

  DIDÁTICA
  Define os parâmetros de entrada da stack de governança.

  OBSERVAÇÃO
  Algumas variáveis extras podem vir do prod.tfvars global.
  Declará-las aqui evita warnings quando o mesmo tfvars é reutilizado
  entre múltiplas stacks.
*/

variable "project_name" {
  type        = string
  description = "Nome do projeto para prefixar os recursos de governança."
}

variable "environment" {
  type        = string
  description = "Ambiente da infraestrutura (dev, staging ou prod)."
}

variable "aws_region" {
  type        = string
  description = "Região AWS."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão aplicadas aos recursos."
  default     = {}
}

variable "domain_name" {
  type        = string
  description = "Domínio principal do projeto."
  default     = ""
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted Zone ID do Route53."
  default     = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN do certificado ACM."
  default     = ""
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN do provider OIDC do EKS."
  default     = ""
}