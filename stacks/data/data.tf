/*
  stacks/data/data.tf

  FUNÇÃO:
  Lê os OUTPUTS das stacks de Networking e Security via S3.
  Isso evita que você precise digitar IDs de VPC ou Subnets manualmente.
*/

# State remoto da stack networking
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = var.remote_state_key_networking
    region = var.aws_region
  }
}

# State remoto da stack security
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = var.remote_state_key_security
    region = var.aws_region
  }
}

locals {
  # IMPORTANTE: Os nomes à direita (.vpc_id, etc) devem existir no outputs.tf das stacks anteriores
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  rds_sg_id   = data.terraform_remote_state.security.outputs.sg_rds_id
  redis_sg_id = data.terraform_remote_state.security.outputs.sg_redis_id
}