/*
  data.tf (stack 06-edge-delivery)

  OBJETIVO:
  Ler estados remotos das stacks anteriores, caso a camada de entrega
  precise consumir algum dado já provisionado.

  OBSERVAÇÃO:
  - Nesta versão da stack, o recurso principal é o bucket S3 do frontend.
  - Mesmo sem usar todos os remote states agora, manter este arquivo pronto
    facilita expansão futura (CloudFront, Route53, ACM, integrações etc.).
*/

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/networking/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/security/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "compute_eks" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/compute-eks/terraform.tfstate"
    region = var.aws_region
  }
}