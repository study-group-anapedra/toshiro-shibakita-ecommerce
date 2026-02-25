/*
  stacks/edge-delivery/provider.tf

  OBJETIVO:
  Configurar o acesso à AWS para criar os recursos de borda (ALB/CloudFront).

  RELEVÂNCIA:
  - Remove o uso de profiles locais para permitir a autenticação via OIDC no GitHub Actions.
  - Aplica tags automáticas para garantir que todos os recursos de rede sejam rastreáveis.
*/

provider "aws" {
  region = var.aws_region

  # Tags padrão para controle de custos e organização enterprise
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