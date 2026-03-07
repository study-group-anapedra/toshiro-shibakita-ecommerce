/*
  backend.tf (stack 09-governance)

  OBJETIVO:
  Definir onde o Terraform armazenará o state remoto desta stack.

  CORREÇÃO APLICADA:
  - Ajustado de dev para prod
  - Ajustado o caminho da key para seguir o padrão do pipeline:
      prod/governance/terraform.tfstate

  IMPORTANTE:
  - Este arquivo representa o backend padrão da stack.
  - No GitHub Actions, o terraform init -backend-config pode sobrescrever
    estes valores dinamicamente.
  - Mesmo assim, deixar este arquivo coerente evita confusão em execuções locais.
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-prod-tfstate"
    key            = "prod/governance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"
  }
}