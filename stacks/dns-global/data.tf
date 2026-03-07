/*
  data.tf (stack 07-dns-global)

  OBJETIVO
  Buscar a hosted zone pública já existente no Route 53
  e ler o remote state da stack anterior.

  CORREÇÕES
  - ajustado nome da stack no comentário: 07-dns-global
  - ajustado key do remote state para o padrão do pipeline:
      prod/edge-delivery/terraform.tfstate
*/

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

data "terraform_remote_state" "edge" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/edge-delivery/terraform.tfstate"
    region = var.aws_region
  }
}