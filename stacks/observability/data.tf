/*
  data.tf (stack 08-observability)

  DIDÁTICA
  Esta stack consome os states remotos das stacks anteriores
  para reutilizar dados já provisionados.

  CORREÇÃO
  As keys do remote state precisam bater com o padrão real do backend remoto:
  - prod/compute-eks/terraform.tfstate
  - prod/edge-delivery/terraform.tfstate
*/

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/compute-eks/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "edge" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/edge-delivery/terraform.tfstate"
    region = var.aws_region
  }
}