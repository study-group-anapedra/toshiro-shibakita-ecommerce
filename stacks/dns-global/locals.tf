/*
  data.tf (stack 06-dns-global)
  DIDÁTICA: Busca a zona 'asantanadev.com' que já existe na sua conta.
*/

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# Remote state da stack 05 (edge-delivery) para pegar o DNS do CloudFront/ALB futuramente
data "terraform_remote_state" "edge" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "edge-delivery/terraform.tfstate"
    region = var.aws_region
  }
}