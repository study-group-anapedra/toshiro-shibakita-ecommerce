/*
  variables.tf (stack 07-dns-global)

  FUNÇÃO
  Declarar variáveis da stack de DNS e certificados.
*/

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "remote_backend_bucket_name" {
  description = "Nome do bucket remoto onde ficam os tfstates"
  type        = string
}

variable "domain_name" {
  description = "Domínio principal do projeto"
  type        = string
  default     = "asantanadev.com"
}

variable "tags" {
  description = "Tags padrão aplicadas aos recursos"
  type        = map(string)
  default     = {}
}