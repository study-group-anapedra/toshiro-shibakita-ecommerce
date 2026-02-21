/*
  data.tf (stack 03-data)

  DIDÁTICA:
  - Este arquivo faz a "ponte" automática entre as stacks.
  - Ele lê o arquivo .tfstate do S3 para pegar IDs sem você precisar digitar.
  - O segredo é o 'outputs.tf' da stack anterior ter o mesmo nome que chamamos aqui.
*/

# Busca dados da rede (VPC e Subnets)
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "toshiro-ecommerce-dev-tfstate"
    key    = "01-networking/terraform.tfstate"
    region = "us-east-1"
  }
}

# Busca dados de segurança (Security Groups)
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "toshiro-ecommerce-dev-tfstate"
    key    = "security/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  # Pega os IDs automáticos da rede
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  # CORREÇÃO: Mapeando os nomes exatos que estão no outputs.tf da security
  rds_sg_id   = data.terraform_remote_state.security.outputs.sg_rds_id
  redis_sg_id = data.terraform_remote_state.security.outputs.sg_redis_id
}