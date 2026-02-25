/*
  stacks/edge-delivery/provider.tf

  OBJETIVO:
  Configurar o acesso à AWS para criar os recursos de borda (ALB/CloudFront).

  RELEVÂNCIA:
  - Remove o uso de profiles locais para permitir a autenticação via OIDC no GitHub Actions.
  - Aplica tags automáticas para garantir que todos os recursos de rede sejam rastreáveis.

   OBJETIVO: Configurar acesso para recursos de borda (ALB/CloudFront).
*/


provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
        Stack       = "06-edge-delivery"
      },
      var.tags
    )
  }
}