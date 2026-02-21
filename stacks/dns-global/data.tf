/*
  data.tf (stack 06-dns-global)
*/

# Busca a zona que você já criou manualmente ou em outra stack
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}