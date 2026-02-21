/*
  backend.tf

  Este arquivo define onde o Terraform armazenará o state
  da stack "security".

  Cada pasta (networking, security, etc.) possui
  seu próprio state isolado no S3.

  Isso reduz o blast radius e permite destruir uma stack
  sem afetar as outras.
*/

terraform {
  backend "s3" {

    # Bucket criado na stack 00-bootstrap
    bucket = "toshiro-ecommerce-dev-tfstate"

    # Caminho do state dentro do bucket
    # Como a pasta se chama "security",
    # o caminho precisa refletir exatamente isso.
    key = "security/terraform.tfstate"

    region         = "us-east-1"
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"

    encrypt = true
  }
}
