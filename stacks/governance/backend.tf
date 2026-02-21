terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-dev-tfstate"
    key            = "governance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"
  }
}