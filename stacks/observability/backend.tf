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

  CORREÇÕES APLICADAS
  - Alterado bucket de dev → prod
  - Ajustado caminho da key para seguir o padrão das stacks:

      prod/observability/terraform.tfstate

  PADRÃO DE BACKEND DAS STACKS
      S3 Bucket  → toshiro-ecommerce-prod-tfstate
      Lock Table → toshiro-ecommerce-prod-tfstate-lock
      Região     → us-east-1

  IMPORTANTE
  No GitHub Actions o comando terraform init pode sobrescrever estes valores
  usando -backend-config, mas manter este arquivo correto evita erros em
  execuções locais e facilita manutenção da infraestrutura.
*/

terraform {

  backend "s3" {

    # Bucket onde ficam todos os estados Terraform do projeto
    bucket = "toshiro-ecommerce-prod-tfstate"

    # Caminho do state desta stack
    key = "prod/observability/terraform.tfstate"

    # Região AWS
    region = "us-east-1"

    # Criptografia do state
    encrypt = true

    # Tabela DynamoDB usada para lock de state
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"

  }

}