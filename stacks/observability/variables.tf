/*
  variables.tf (stack 07-observability)
  DIDÁTICA: Define os parâmetros básicos para identificação dos recursos de monitoramento.
*/

variable "project_name" {
  type        = string
  description = "Nome do projeto para prefixar os dashboards e grupos de logs."
}

variable "environment" {
  type        = string
  description = "Ambiente (dev, staging, prod)."
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 que armazena os estados das outras stacks."
}

variable "tags" {
  type    = map(string)
  default = {}
}