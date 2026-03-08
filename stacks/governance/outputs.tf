/*
  outputs.tf (stack 09-governance)

  Exporta informações úteis da stack de governança
  para validação e integrações futuras.
*/

output "audit_bucket_name" {
  description = "Nome do bucket S3 que armazena os logs de auditoria."
  value       = aws_s3_bucket.audit_logs.bucket
}

output "audit_bucket_arn" {
  description = "ARN do bucket S3 de auditoria."
  value       = aws_s3_bucket.audit_logs.arn
}

output "cloudtrail_name" {
  description = "Nome da trilha principal do CloudTrail."
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  description = "ARN da trilha principal do CloudTrail."
  value       = aws_cloudtrail.main.arn
}