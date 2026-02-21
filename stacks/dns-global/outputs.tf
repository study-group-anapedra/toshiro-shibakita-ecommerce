output "certificate_arn" {
  value       = aws_acm_certificate.wildcard.arn
  description = "ARN do certificado SSL para usar no ALB ou CloudFront"
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.main.zone_id
}