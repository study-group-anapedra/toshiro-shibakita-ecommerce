/*
  dev.tfvars

  FUNÇÃO DIDÁTICA:
  - Este arquivo contém os VALORES reais que o Terraform vai injetar na infra.
  - CORREÇÃO: Adicionamos rds_security_group_id e redis_security_group_id.
  - Com esses valores aqui, o Terraform não precisa mais te perguntar nada no terminal.
*/

# Nome base da infraestrutura da aplicação
project_name = "toshiro-ecommerce"

# Ambiente atual
environment  = "dev"

# Região AWS onde os recursos serão criados
aws_region   = "us-east-1"

# =========================================================
# Networking e Segurança (IDs capturados do seu terminal)
# =========================================================

# ID da VPC (Certifique-se de que este valor está correto para sua conta)
# vpc_id = "vpc-xxxxxxxxxxxxxxxxx" 

# IDs das Subnets Privadas (Necessário para RDS e Redis)
# private_subnet_ids = ["subnet-xxxx", "subnet-yyyy"]

# CORREÇÃO: IDs dos Security Groups que você listou anteriormente
rds_security_group_id   = "sg-047adaa6a245939c7"
redis_security_group_id = "sg-0be264521cb300bca"

# =========================================================
# Credenciais do Banco (DevSecOps: use senhas fortes)
# =========================================================
db_password = "SuaSenhaSeguraAqui123" # Altere para sua senha real

# =========================================================
# Backend e Governança
# =========================================================

# Nome do bucket S3 que armazena o Terraform state remoto
remote_backend_bucket_name    = "toshiro-ecommerce-dev-tfstate"

# Nome da tabela DynamoDB usada para lock do Terraform
remote_backend_dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"

# CIDR da VPC para ambiente dev
vpc_cidr = "10.0.0.0/16"

# Tags para governança e organização
tags = {
  Project     = "toshiro-ecommerce"
  Environment = "dev"
  Owner       = "ana"
  ManagedBy   = "terraform"
}

