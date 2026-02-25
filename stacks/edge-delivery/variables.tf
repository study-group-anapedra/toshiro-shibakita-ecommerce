/*
  variables.tf (stack 06-edge-delivery)
  DIDÁTICA: Define os parâmetros de entrada da camada de entrega (ALB + Certificados).
*/

variable "project_name" {
  description = "Nome do projeto para padronização dos recursos"
  type        = string
}

variable "environment" {
  description = "Ambiente da infraestrutura (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "remote_backend_bucket_name" {
  description = "Nome do bucket S3 onde ficam os states das stacks anteriores"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM para habilitar HTTPS no ALB (opcional)."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags padrão aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
}