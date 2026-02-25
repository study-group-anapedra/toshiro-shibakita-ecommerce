/*
  stacks/compute-eks/provider.tf
  FUNÇÃO: Configurar o provedor AWS para o EKS.
  
  MUDANÇA: Removido o 'profile' local para permitir que o GitHub Actions 
  se autentique via OIDC automaticamente.
*/

provider "aws" {
  region = var.aws_region

  # Removido: profile = "terraform-dev"

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
        Stack       = "04-compute-eks"
      },
      var.tags
    )
  }
}