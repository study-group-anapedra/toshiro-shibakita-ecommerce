/*
  variables.tf (stack 06-dns-global)
  FUNÇÃO: Declarar variáveis para o DNS e Certificados.
*/

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "remote_backend_bucket_name" {
  type = string
}

variable "domain_name" {
  description = "Domínio principal do projeto"
  type        = string
  default     = "asantanadev.com"
}

variable "tags" {
  type    = map(string)
  default = {}
}