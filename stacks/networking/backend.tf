/*
  backend.tf

  Define onde o Terraform armazenará o STATE da stack networking.

  Cada stack possui seu próprio state dentro do bucket S3.
  Isso permite execução independente e evita conflito entre stacks.
*/

terraform {
  backend "s3" {

    # Bucket criado na stack bootstrap
    bucket = "toshiro-ecommerce-prod-tfstate"

    # Caminho do state desta stack dentro do bucket
    key = "prod/networking/terraform.tfstate"

    # Região AWS
    region = "us-east-1"

    # Tabela de lock do Terraform
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"

    # Criptografia do state
    encrypt = true
  }
}
