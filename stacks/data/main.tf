/*
  main.tf (stack 03-data)

  FUNÇÃO DIDÁTICA:
  - Este é o "Orquestrador". Ele decide o que será criado lendo o locals.tf.
  - CORREÇÃO: Agora ele passa rds_security_group_id para o RDS e 
    redis_security_group_id para o ElastiCache.
  - Isso evita que o Redis tente usar as regras de acesso do PostgreSQL e vice-versa.
*/

# ---------------------------------------------------------
# Liga/desliga automático com base no mapa (locals.tf)
# ---------------------------------------------------------
locals {
  enable_postgres = length(local.postgres_domains) > 0
  enable_redis    = length(local.redis_domains) > 0
  enable_dynamodb = length(local.dynamodb_domains) > 0
}

module "rds" {
  source = "./rds"
  count  = local.enable_postgres ? 1 : 0

  project_name = var.project_name
  environment  = var.environment

  vpc_id                     = local.vpc_id
  private_subnet_ids         = local.private_subnet_ids
  database_security_group_id = local.rds_sg_id

  db_password = var.db_password
  tags        = var.tags
}

module "elasticache" {
  source = "./elasticache"
  count  = local.enable_redis ? 1 : 0

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids      = local.private_subnet_ids
  redis_security_group_id = local.redis_sg_id
  
  redis_cluster_name      = local.redis_cluster_name
  tags                    = var.tags
}

module "dynamodb" {
  source = "./dynamodb"
  count  = local.enable_dynamodb ? 1 : 0

  project_name    = var.project_name
  environment     = var.environment
  dynamodb_prefix = local.dynamodb_prefix
  domains         = local.dynamodb_domains
  tags            = var.tags
}