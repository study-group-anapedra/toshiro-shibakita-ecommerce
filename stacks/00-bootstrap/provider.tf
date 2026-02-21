# provider.tf
# -------------------------------------------------------------------
# Configuração do provider AWS.
# Define:
# - Região onde os recursos serão criados
# - Profile AWS a ser utilizado (quando aplicável)
# - Tags padrão aplicadas automaticamente a todos os recursos
# -------------------------------------------------------------------

provider "aws" {
  # Região AWS (ex: us-east-1)
  region = var.aws_region

  # Profile opcional (usado em ambiente local)
  # Em CI/CD (OIDC), normalmente não é utilizado
  profile = var.aws_profile

  # Tags padrão aplicadas a todos os recursos criados
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

