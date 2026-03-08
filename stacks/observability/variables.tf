/*
  variables.tf (stack 08-observability)

  DIDÁTICA
  Define os parâmetros necessários para esta stack de observabilidade.

  OBSERVAÇÃO
  Algumas variáveis vêm do prod.tfvars global.
  Mesmo que não sejam usadas diretamente aqui, declará-las evita warnings
  no pipeline quando o mesmo arquivo tfvars é reutilizado entre stacks.
*/

variable "project_name" {
  type        = string
  description = "Nome do projeto."
}

variable "environment" {
  type        = string
  description = "Ambiente da infraestrutura (dev, staging, prod)."
}

variable "aws_region" {
  type        = string
  description = "Região AWS."
  default     = "us-east-1"
}

variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 que armazena os states remotos."
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

variable "tags" {
  type        = map(string)
  description = "Tags padrão dos recursos."
  default     = {}
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