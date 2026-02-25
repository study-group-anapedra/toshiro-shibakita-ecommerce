/*
  data.tf (stack 04-compute-eks)
  FUNÇÃO: Buscar informações das stacks 01, 02 e 03.
  POR QUE: O EKS precisa saber quais subnets usar e qual SG (Security Group) aplicar aos nós.
*/

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    # CORREÇÃO: Adicionado 'prod/'
    key    = "prod/networking/terraform.tfstate" 
    region = var.aws_region
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    # CORREÇÃO: Adicionado 'prod/'
    key    = "prod/security/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    # CORREÇÃO: Adicionado 'prod/'
    key    = "prod/data/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids
  nodes_sg_id        = data.terraform_remote_state.security.outputs.sg_apps_id
}