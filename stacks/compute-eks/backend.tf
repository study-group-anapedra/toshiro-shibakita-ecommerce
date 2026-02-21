/*
  backend.tf (stack 04-compute-eks)
  FUNÇÃO: Salvar o estado da infraestrutura no S3.
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-dev-tfstate" # Substitua pelo nome do seu bucket se for diferente
    key            = "compute-eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"
  }
}