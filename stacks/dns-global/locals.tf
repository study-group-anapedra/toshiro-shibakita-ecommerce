/*
  locals.tf (stack 07-dns-global)

  OBJETIVO
  Declarar apenas valores locais reutilizáveis.

  CORREÇÃO
  - removido o data "aws_route53_zone" "main" duplicado
*/

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}