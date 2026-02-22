/*
  data.tf (stack 03-data)
  
  O QUE FAZ: 
  Busca os "endereços" e "portas" criados nas stacks anteriores (Networking e Security).
  
  COM QUEM CONVERSA:
  - Stack 01 (Networking): Para saber em quais subnets o banco pode "morar".
  - Stack 02 (Security): Para pegar as regras de Firewall (Security Groups).
  
  RELEVÂNCIA: 
  Garante que o banco de dados seja criado exatamente dentro da infraestrutura
  que você preparou, sem precisar de IDs manuais (hardcoded).
*/

# Busca dados da rede (VPC e Subnets)
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    # Usamos variável para o bucket para que funcione em dev e prod
    bucket = var.remote_backend_bucket_name 
    key    = "01-networking/terraform.tfstate"
    region = var.aws_region
  }
}

# Busca dados de segurança (Security Groups)
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "security/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids
  
  # IDs vindos da stack de segurança
  rds_sg_id   = data.terraform_remote_state.security.outputs.sg_rds_id
  redis_sg_id = data.terraform_remote_state.security.outputs.sg_redis_id
}