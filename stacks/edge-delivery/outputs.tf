/*
  outputs.tf (stack 06-edge-delivery)

  CORREÇÃO APLICADA:
  - Antes este arquivo estava errado porque continha outputs copiados
    da stack 04-compute-eks.
  - Ele referenciava:
      module.eks.*
      aws_ecr_repository.apps
    que não existem nesta stack.

  AGORA:
  - Exporta apenas informações realmente pertencentes à stack 06.
*/

output "frontend_bucket_name" {
  description = "Nome do bucket S3 do frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_arn" {
  description = "ARN do bucket S3 do frontend"
  value       = aws_s3_bucket.frontend.arn
}

output "frontend_bucket_domain_name" {
  description = "Domain name do bucket S3 do frontend"
  value       = aws_s3_bucket.frontend.bucket_domain_name
}

output "frontend_bucket_regional_domain_name" {
  description = "Regional domain name do bucket S3 do frontend"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}