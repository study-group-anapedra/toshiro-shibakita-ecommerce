/*
  backend.tf (stack 05-k8s-addons)

  Este arquivo define onde o Terraform armazenará o state
  da stack "k8s-addons".

  Cada stack (networking, security, compute-eks, k8s-addons, etc.)
  possui seu próprio state isolado dentro do bucket S3 do ambiente.

  Isso permite:
  - isolamento entre stacks (blast radius menor)
  - execução independente no CI/CD
  - destruir/recriar só os addons sem mexer no cluster EKS
*/

terraform {
  backend "s3" {

    # Bucket criado na stack 00-bootstrap
    bucket = "toshiro-ecommerce-dev-tfstate"

    # State isolado desta stack
    key = "k8s-addons/terraform.tfstate"

    # Região AWS
    region = "us-east-1"

    # Tabela de lock criada no bootstrap
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"

    # Criptografia do state
    encrypt = true
  }
}
