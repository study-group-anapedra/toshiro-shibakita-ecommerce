/*
  backend.tf (stack 07-dns-global)

  OBJETIVO
  Definir o backend remoto da stack de DNS global.

  CORREÇÕES
  - trocado bucket dev -> prod
  - trocado dynamodb lock dev -> prod
  - ajustado key para o padrão usado no pipeline:
      prod/dns-global/terraform.tfstate
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-prod-tfstate"
    key            = "prod/dns-global/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"
  }
}