/*
  main.tf (03-data/elasticache)

  O que cria:
  - Subnet Group privado (obrigatório)
  - Replication Group Redis (recomendado ao invés de cluster simples)

  Decisão:
  - dev: normalmente 1 nó, sem multi-az
  - prod: multi-az + failover automático
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"
}

resource "aws_elasticache_subnet_group" "this" {
  name        = "${var.redis_cluster_name}-subnet-group"
  description = "Subnets privadas para Redis (${var.redis_cluster_name})"
  subnet_ids  = var.private_subnet_ids

  tags = merge(
    {
      Name        = "${var.redis_cluster_name}-subnet-group"
      Project     = var.project_name
      Environment = var.environment
      Stack       = "03-data"
      Component   = "elasticache"
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.redis_cluster_name
  description          = "Redis (${var.redis_cluster_name})"

  engine         = "redis"
  engine_version = var.engine_version
  node_type      = var.node_type

  port = 6379

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [var.redis_security_group_id]

  # Modo simples:
  # - dev: 1 nó (sem réplicas)
  # - prod: 2 nós (1 primário + 1 réplica)
  num_cache_clusters = var.multi_az ? 2 : 1

  automatic_failover_enabled = var.multi_az
  multi_az_enabled           = var.multi_az

  # Segurança mínima e boa prática
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = merge(
    {
      Name        = var.redis_cluster_name
      Project     = var.project_name
      Environment = var.environment
      Stack       = "03-data"
      Component   = "elasticache"
      ManagedBy   = "terraform"
    },
    var.tags
  )
}
