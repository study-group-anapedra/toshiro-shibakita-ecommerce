/*
  prod.tfvars

  - Valores do ambiente PROD para as stacks Terraform.
  - Outputs (VPC, SG, Subnets etc.) vêm das outras stacks via remote_state.
  - Nenhum segredo aqui (Secrets Manager / IRSA depois).
*/

# =========================================================
# Identidade do Projeto
# =========================================================
project_name = "toshiro-ecommerce"
environment  = "prod"

# =========================================================
# Região AWS
# =========================================================
aws_region = "us-east-1"

# =========================================================
# Backend remoto (Terraform State)
# =========================================================
remote_backend_bucket_name    = "toshiro-ecommerce-prod-tfstate"
remote_backend_dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"

# =========================================================
# Rede
# =========================================================
vpc_cidr = "10.10.0.0/16"

# =========================================================
# DNS / Certificado existente
# =========================================================
domain_name         = "asantanadev.com"
api_domain_name     = "api.asantanadev.com"
acm_certificate_arn = "arn:aws:acm:us-east-1:365646127398:certificate/63e80d1b-c0cc-402b-a280-409296304096"

# =========================================================
# Governança (Tags padrão)
# =========================================================
tags = {
  Project     = "toshiro-ecommerce"
  Environment = "prod"
  Owner       = "ana"
  ManagedBy   = "terraform"
}