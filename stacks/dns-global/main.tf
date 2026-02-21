/*
  main.tf (stack 06-dns-global)
  DIDÁTICA: Cria o certificado SSL Wildcard e valida automaticamente via DNS.
*/

# 1. Solicitação do Certificado SSL (ACM)
resource "aws_acm_certificate" "wildcard" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"] # Cobre catalog, auth, order, etc.
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# 2. Criação dos Registros de Validação no Route 53
# O Terraform lê o que o ACM pede e cria o CNAME sozinho.
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# 3. Validação do Certificado
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}