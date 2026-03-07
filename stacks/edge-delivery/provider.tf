/*
  provider.tf (stack 06-edge-delivery)

  OBJETIVO:
  Configurar o provider AWS para esta stack.

  CORREÇÃO:
  - Mantido sem profile local
  - Compatível com autenticação via OIDC no GitHub Actions
  - Tags automáticas ajudam em rastreabilidade e governança
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