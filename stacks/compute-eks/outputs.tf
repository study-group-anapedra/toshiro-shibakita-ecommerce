/*
  outputs.tf (stack 04-compute-eks)

  FUNÇÃO:
  Exportar informações essenciais do cluster EKS e dos ECRs
  para outras stacks Terraform consumirem via remote_state.

  QUEM USA ISSO:

  ✔ stack k8s-addons (AWS Load Balancer Controller / IRSA)
  ✔ providers kubernetes e helm
  ✔ CI/CD pipelines
  ✔ outras stacks que precisem do ECR

  IMPORTANTE:

  Terraform NÃO compartilha dados automaticamente entre stacks.
  O remote_state lê exatamente o que você exporta aqui.

  Se faltar output → a próxima stack quebra.
*/


############################################################
# NOME DO CLUSTER
############################################################

# Usado por providers Kubernetes/Helm
# para saber em qual cluster executar ações.
output "cluster_name" {

  description = "Nome do cluster EKS"

  value = module.eks.cluster_name
}


############################################################
# ENDPOINT DA API DO KUBERNETES
############################################################

# Endpoint HTTPS da API Server do Kubernetes.
# Provider kubernetes conecta usando isso.
output "cluster_endpoint" {

  description = "Endpoint da API do cluster EKS"

  value = module.eks.cluster_endpoint
}


############################################################
# CERTIFICADO CA DO CLUSTER
############################################################

# Necessário para conexão TLS segura do provider Kubernetes.
# Evita ataques MITM e valida identidade do cluster.
output "cluster_ca_certificate" {

  description = "Certificado CA do cluster EKS"

  value = module.eks.cluster_certificate_authority_data
}


############################################################
# OIDC PROVIDER ARN (IRSA)
############################################################

# IRSA permite pods Kubernetes assumirem IAM Roles AWS
# SEM access keys dentro do container.

# O AWS Load Balancer Controller depende disso
# para criar ALB automaticamente.
output "oidc_provider_arn" {

  description = "OIDC Provider ARN do cluster (IRSA)"

  value = module.eks.oidc_provider_arn
}


############################################################
# OIDC PROVIDER URL
############################################################

# Usado em trust policies IAM.
output "oidc_provider_url" {

  description = "OIDC Provider URL do cluster"

  value = module.eks.cluster_oidc_issuer_url
}


############################################################
# REPOSITÓRIOS ECR (MICROSSERVIÇOS)
############################################################

# Exporta os ECRs criados automaticamente
# para cada serviço definido em locals.services.

# Exemplo de retorno:

# {
#   "catalog-service"   = "...amazonaws.com/dev-project/catalog-service"
#   "order-service"     = "...amazonaws.com/dev-project/order-service"
# }

# Isso permite CI/CD fazer push automático das imagens.
output "ecr_repository_urls" {

  description = "Mapa com URLs dos repositórios ECR por serviço"

  value = {
    for k, v in aws_ecr_repository.apps :
    k => v.repository_url
  }
}