# versions.tf
# -------------------------------------------------------------------
# Este arquivo define:
# 1) A versão mínima do Terraform que pode executar este projeto
# 2) As versões dos providers (ex: AWS) permitidas
# -------------------------------------------------------------------

terraform {
  # Versão mínima do Terraform requerida
  required_version = ">= 1.6.0"

  # Providers necessários para este stack
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Permite qualquer versão 5.x estável
      version = "~> 5.0"
    }
  }
}
