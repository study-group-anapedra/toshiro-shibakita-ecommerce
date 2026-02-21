/*
  versions.tf (stack 03-data)

  Objetivo:
  - Fixar versões mínimas do Terraform e providers.
  - Garantir reprodutibilidade (aplicar hoje ou daqui 6 meses dá o mesmo resultado).

  Por que isso importa:
  - Infra de dados (RDS/Redis) é crítica.
  - Mudanças de versão do provider podem alterar comportamento silenciosamente.
*/

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
