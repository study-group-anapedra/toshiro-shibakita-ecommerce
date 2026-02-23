/*
  main.tf (stack 03-data)

  O QUE FAZ:
  - Este é o "orquestrador" da stack 03-data: ele chama os módulos (RDS, Redis, DynamoDB).
  - Ele liga/desliga módulos automaticamente (via locals) sem você precisar comentar código.
  - Ele usa os IDs vindos de remote_state (data.tf) para não copiar/colar VPC/Subnets/SG.

  COM QUEM CONVERSA:
  - data.tf -> fornece local.vpc_id, local.private_subnet_ids, local.rds_sg_id, local.redis_sg_id
  - ./rds, ./elasticache, ./dynamodb -> módulos chamados aqui

  RELEVÂNCIA:
  - Não pede senha em CI/CD (RDS com senha gerenciada pela AWS).
  - Evita erro de “Unsupported argument” removendo inputs que o módulo não declara.
*/

# ---------------------------------------------------------
# Liga/desliga automático com base no mapa (locals.tf)
# ---------------------------------------------------------
locals {
  enable_postgres = length(local.postgres_domains) > 0
  enable_redis    = length(local.redis_domains) > 0
  enable_dynamodb = length(local.dynamodb_domains) > 0
}

# ---------------------------------------------------------
# RDS (PostgreSQL) — senha gerenciada automaticamente pela AWS
# ---------------------------------------------------------
module "rds" {
  source = "./rds"
  count  = local.enable_postgres ? 1 : 0

  project_name = var.project_name
  environment  = var.environment

  # IDs vêm do remote_state (stacks/data/data.tf -> locals)
  private_subnet_ids         = local.private_subnet_ids
  database_security_group_id = local.rds_sg_id

  # Configuração do banco (sem senha aqui)
  db_name           = var.db_name
  db_username       = var.db_username
  db_instance_class = var.db_instance_class

  allocated_storage_gb     = var.allocated_storage_gb
  max_allocated_storage_gb = var.max_allocated_storage_gb
  multi_az                 = var.multi_az
  backup_retention_days    = var.backup_retention_days
  deletion_protection      = var.deletion_protection
  skip_final_snapshot      = var.skip_final_snapshot

  tags = var.tags
}

# ---------------------------------------------------------
# ElastiCache (Redis)
# ---------------------------------------------------------
module "elasticache" {
  source = "./elasticache"
  count  = local.enable_redis ? 1 : 0

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids      = local.private_subnet_ids
  redis_security_group_id = local.redis_sg_id

  redis_cluster_name = local.redis_cluster_name
  tags               = var.tags
}

# ---------------------------------------------------------
# DynamoDB
# ---------------------------------------------------------
module "dynamodb" {
  source = "./dynamodb"
  count  = local.enable_dynamodb ? 1 : 0

  project_name    = var.project_name
  environment     = var.environment
  dynamodb_prefix = local.dynamodb_prefix
  domains         = local.dynamodb_domains
  tags            = var.tags
}