/*
  variables.tf (stack 08-governance)
  DIDÁTICA: Define os parâmetros de entrada. O Terraform usa apenas quebras de linha.
*/

variable "project_name" {
  type        = string
  description = "Nome do projeto para prefixar os recursos de auditoria."
}

variable "environment" {
  type        = string
  description = "Ambiente da infraestrutura (dev, staging ou prod)."
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 onde estão os states anteriores."
}

variable "tags" {
  type    = map(string)
  default = {}
}