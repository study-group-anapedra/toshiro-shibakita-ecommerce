/*
  outputs.tf (stack 07-dns-global)

  OBJETIVO:
  Expor valores úteis da stack de DNS para consumo por outras stacks.

  PAPEL NA ARQUITETURA:
  - Entrega o ID da hosted zone pública localizada
  - Entrega o domínio principal
  - Entrega o subdomínio principal da API
  - Repassa o ARN do certificado ACM existente
*/

output "certificate_arn" {
  description = "ARN do certificado ACM já existente"
  value       = var.acm_certificate_arn
}

output "hosted_zone_id" {
  description = "ID da hosted zone pública principal"
  value       = data.aws_route53_zone.main.zone_id
}

output "domain_name" {
  description = "Domínio principal do projeto"
  value       = var.domain_name
}

output "api_domain_name" {
  description = "Subdomínio principal da API"
  value       = var.api_domain_name
}