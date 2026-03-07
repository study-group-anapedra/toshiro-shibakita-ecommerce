/*
  backend.tf (stack 05-k8s-addons)

  Este arquivo define onde o Terraform armazenará o state
  da stack "k8s-addons".

  Cada stack possui seu próprio state isolado dentro do bucket S3.
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-prod-tfstate"
    key            = "prod/k8s-addons/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"
    encrypt        = true
  }
}
