/*
  variables.tf (stack 07-dns-global)

  OBJETIVO:
  Declarar as entradas da stack responsável pela camada de DNS.

  PAPEL NA ARQUITETURA:
  - Recebe o domínio principal já existente no Route 53
  - Recebe o subdomínio principal da API
  - Recebe o ARN de um certificado ACM já emitido e reutilizado
  - Permite que a stack publique registros DNS sem recriar certificado

  RELAÇÃO COM OUTRAS PARTES:
  - Conversa com a Hosted Zone já existente no Route 53
  - Pode conversar com a stack de edge quando for necessário apontar
    domínios para ALB, CloudFront ou outro endpoint público

  RECURSOS AWS ENVOLVIDOS:
  - Route 53
  - ACM (somente como referência ao certificado existente)

  RELEVÂNCIA:
  - Evita retrabalho com nova validação de certificado
  - Reduz tempo de pipeline
  - Mantém o domínio centralizado e reaproveitável
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
  description = "Domínio raiz já existente no Route 53"
  type        = string
}

variable "api_domain_name" {
  description = "Subdomínio principal da API"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM já emitido e reutilizado pela arquitetura"
  type        = string
}

variable "tags" {
  description = "Tags padrão aplicadas aos recursos"
  type        = map(string)
  default     = {}
}