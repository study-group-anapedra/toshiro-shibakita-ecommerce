/*
  variables.tf (stack 07-dns-global)

  OBJETIVO:
  Declarar as entradas da stack de DNS usando
  domínio e certificado ACM já existentes.

  PAPEL:
  - recebe o domínio raiz
  - recebe o subdomínio principal da API
  - recebe o ARN do certificado já emitido no ACM
  - permite que a stack consuma recursos existentes
    sem recriar certificado e sem nova validação DNS
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
  description = "Domínio raiz já existente no Route53"
  type        = string
}

variable "api_domain_name" {
  description = "Subdomínio principal da API"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM já existente e emitido"
  type        = string
}

variable "tags" {
  description = "Tags padrão aplicadas aos recursos"
  type        = map(string)
  default     = {}
}