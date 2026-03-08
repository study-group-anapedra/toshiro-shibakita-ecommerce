/*
  backend.tf (stack 09-governance)

  OBJETIVO
  Definir onde o Terraform armazenará o state remoto desta stack.

  CONTEXTO
  A stack 09-governance concentra recursos de auditoria e governança,
  como CloudTrail e armazenamento seguro dos logs de auditoria.

  PADRÃO DE BACKEND DAS STACKS
  - Bucket S3 de state remoto
  - Lock via DynamoDB
  - Região padronizada em us-east-1

  IMPORTANTE
  No GitHub Actions, o terraform init pode sobrescrever estes valores com
  -backend-config, mas manter este arquivo correto evita inconsistências
  em execuções locais.
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