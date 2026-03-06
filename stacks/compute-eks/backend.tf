/*
  backend.tf (stack 04-compute-eks)

  Este arquivo define onde o Terraform armazenará o state
  da stack "compute-eks".

  Cada stack possui seu próprio arquivo terraform.tfstate
  dentro do bucket S3 do ambiente.

  Isso permite:
  - isolamento entre stacks
  - menor blast radius
  - execução independente no CI/CD
*/

terraform {
  backend "s3" {

    # Bucket criado na stack 00-bootstrap
    bucket = "toshiro-ecommerce-prod-tfstate"

    # Caminho do state desta stack dentro do bucket
    key = "prod/compute-eks/terraform.tfstate"

    # Região AWS
    region = "us-east-1"

    # Lock do Terraform
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"

    # Criptografia do state
    encrypt = true
  }
}