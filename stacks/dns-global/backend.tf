/*
  backend.tf (stack 06-dns-global)
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-dev-tfstate"
    key            = "dns-global/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"
  }
}