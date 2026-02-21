/*
  data.tf (stack 07-observability)
  DIDÁTICA: Busca informações das stacks anteriores para integrar o monitoramento.
*/

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "compute-eks/terraform.tfstate"
    region = var.aws_region
  }
}

# Remote state da stack 05-edge-delivery para monitorar CloudFront/ALB
data "terraform_remote_state" "edge" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "edge-delivery/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  cluster_name = data.terraform_remote_state.compute.outputs.cluster_name
  # Pega o ARN do certificado SSL da stack de DNS/Edge se necessário
}