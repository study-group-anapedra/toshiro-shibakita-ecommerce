/*
  variables.tf (stack 06-edge-delivery)

  OBJETIVO:
  Declarar os parâmetros de entrada desta stack.

  OBSERVAÇÃO:
  - Algumas variáveis podem não ser usadas nesta versão inicial,
    mas foram mantidas para evolução futura da camada de entrega.
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
  description = "ARN do certificado ACM para uso futuro em HTTPS/CloudFront/ALB"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags padrão aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
}