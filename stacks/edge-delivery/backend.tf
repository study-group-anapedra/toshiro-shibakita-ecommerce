/*
  backend.tf (stack 06-edge-delivery)

  OBJETIVO:
  Definir onde o Terraform vai armazenar o state desta stack.

  CORREÇÃO APLICADA:
  - Antes estava apontando para bucket/key errados
  - Estava usando:
      bucket de dev
      key da stack compute-eks
  - Agora aponta corretamente para a stack 06 em prod

  IMPORTANTE:
  - No GitHub Actions, o terraform init -reconfigure com backend-config
    sobrescreve estes valores.
  - Mesmo assim, este arquivo precisa estar coerente para uso local e manutenção.
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-prod-tfstate"
    key            = "prod/edge-delivery/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"
  }
}