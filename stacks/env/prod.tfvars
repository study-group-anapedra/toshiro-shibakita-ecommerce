# =========================================================
# prod.tfvars
# RELEVÂNCIA: Centraliza os nomes dos recursos de produção.
# =========================================================

project_name = "toshiro-ecommerce"
environment  = "prod"
aws_region   = "us-east-1"

# Configurações do Backend (Resolvendo os Warnings do log)
remote_backend_bucket_name    = "toshiro-ecommerce-prod-tfstate"
remote_backend_dynamodb_table = "toshiro-ecommerce-prod-tfstate-lock"

# Networking
vpc_cidr = "10.10.0.0/16"

# Tags
tags = {
  Project     = "toshiro-ecommerce"
  Environment = "prod"
  Owner       = "ana"
  ManagedBy   = "terraform"
}