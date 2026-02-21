/*
  data.tf (stack 04-compute-eks)
  FUNÇÃO: Buscar informações das stacks 01, 02 e 03.
  POR QUE: O EKS precisa saber quais subnets usar e qual SG (Security Group) aplicar aos nós.
*/

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "networking/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "security/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "data/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids
  # Security Group que criamos para as APPS na stack 02
  nodes_sg_id        = data.terraform_remote_state.security.outputs.sg_apps_id
}