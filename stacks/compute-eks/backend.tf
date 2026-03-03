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
    bucket = "toshiro-ecommerce-dev-tfstate"

    # State ISOLADO desta stack (compute-eks)
    key = "compute-eks/terraform.tfstate"

    region         = "us-east-1"
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"
    encrypt        = true
  }
}
