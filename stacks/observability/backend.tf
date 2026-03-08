/*
  backend.tf (stack 08-observability)

  OBJETIVO
  Definir onde o Terraform armazenará o state remoto desta stack.

  CONTEXTO
  A stack de observabilidade normalmente cria recursos como:
  - CloudWatch Dashboards
  - Log Groups
  - Alarmes
  - Métricas customizadas
  - Integrações de monitoramento

  Portanto é essencial manter o state remoto consistente.

  PADRÃO DE BACKEND DAS STACKS
  S3 Bucket  → toshiro-ecommerce-prod-tfstate
  Lock Table → toshiro-ecommerce-prod-tfstate-lock
  Região     → us-east-1
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-prod-tfstate"
    key            = "prod/observability/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"
  }
}