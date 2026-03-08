/*
  variables.tf (stack 09-governance)

  DIDÁTICA
  Define os parâmetros de entrada da stack de governança.

  OBSERVAÇÃO
  Algumas variáveis extras vêm do prod.tfvars global.
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

variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 do backend remoto."
  default     = ""
}

variable "remote_backend_dynamodb_table" {
  type        = string
  description = "Tabela DynamoDB de lock do backend remoto."
  default     = ""
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR da VPC."
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "Domínio principal do projeto."
  default     = ""
}

variable "api_domain_name" {
  type        = string
  description = "Domínio público da API."
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

variable "tags" {
  type        = map(string)
  description = "Tags padrão aplicadas aos recursos."
  default     = {}
}