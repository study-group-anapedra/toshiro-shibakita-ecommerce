/*
  data.tf (stack 04-compute-eks)
  DIDÁTICA: Busca informações de rede e segurança para injetar no EKS.
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
  backend = "s3"/*
  stacks/edge-delivery/data.tf

  FUNÇÃO:
  Busca informações de rede e segurança para injetar no Load Balancer.

  COMUNICA COM:
  ✔ prod/networking/terraform.tfstate (VPC e Subnets Públicas)
  ✔ prod/security/terraform.tfstate (Security Group do ALB)
*/

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    # CORREÇÃO: Adicionado prefixo 'prod/' para alinhar com o workflow
    key    = "prod/networking/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    # CORREÇÃO: Adicionado prefixo 'prod/' para alinhar com o workflow
    key    = "prod/security/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.networking.outputs.public_subnet_ids
  # SG do ALB criado na stack 02 para permitir tráfego da internet
  alb_sg_id         = data.terraform_remote_state.security.outputs.sg_alb_id
}
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "security/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids
  # SG de apps criado na stack 02 para permitir acesso ao RDS/Redis
  nodes_sg_id        = data.terraform_remote_state.security.outputs.sg_apps_id
}