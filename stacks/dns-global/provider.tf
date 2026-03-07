/*
  provider.tf (stack 07-dns-global)

  OBJETIVO
  Configurar o provider AWS da stack de DNS.

  CORREÇÕES
  - removido profile local, porque no GitHub Actions a autenticação é via OIDC
  - mantidas tags padrão
*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
        Stack       = "07-dns-global"
      },
      var.tags
    )
  }
}