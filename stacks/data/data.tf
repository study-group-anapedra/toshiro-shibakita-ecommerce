/*
  stacks/data/data.tf

  Função deste arquivo
  --------------------
  Este arquivo “liga” a stack 03-data às stacks anteriores (networking e security)
  sem você copiar/colar IDs (VPC, subnets, security groups).

  Como ele faz isso
  -----------------
  Ele lê os OUTPUTS publicados no state remoto (S3) das stacks anteriores.
  Ou seja: networking/security exportam outputs -> aqui a stack data consome.

  IMPORTANTE
  ----------
  Os keys precisam bater com o caminho real do state no S3.
  No seu workflow, os keys são:
    prod/networking/terraform.tfstate
    prod/security/terraform.tfstate
*/

# ---------------------------------------------------------
# State remoto da stack networking (VPC + Subnets)
# ---------------------------------------------------------
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = var.remote_state_key_networking
    region = var.aws_region
  }
}

# ---------------------------------------------------------
# State remoto da stack security (SGs)
# ---------------------------------------------------------
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = var.remote_state_key_security
    region = var.aws_region
  }
}

# ---------------------------------------------------------
# Consolida “valores finais” para a stack data usar
# ---------------------------------------------------------
locals {
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  # Ajuste SOMENTE se seus outputs.tf tiverem nomes diferentes
  rds_sg_id   = data.terraform_remote_state.security.outputs.sg_rds_id
  redis_sg_id = data.terraform_remote_state.security.outputs.sg_redis_id
}