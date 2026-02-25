/*
  stacks/compute-eks/outputs.tf
  FUNÇÃO: Exportar informações do cluster.
*/

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster EKS"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN do cluster (IRSA)"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL do cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "ecr_repository_urls" {
  description = "Mapa com URLs dos repositórios ECR por serviço"
  value = {
    for k, v in aws_ecr_repository.apps :
    k => v.repository_url
  }
}