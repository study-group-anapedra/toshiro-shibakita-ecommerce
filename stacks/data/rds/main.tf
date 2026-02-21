/*
  main.tf (03-data/rds)

  O que este “módulo interno” faz:
  - Cria o DB Subnet Group (para garantir RDS em subnets privadas).
  - Cria a instância RDS PostgreSQL (produção-ready).

  Observações:
  - Este código NÃO cria VPC/SG: ele só CONSUME vpc_id, subnets e SG já prontos.
  - Senha vem por variável sensível (idealmente via CI/CD + secrets).
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"

  # Nome “humano” e padronizado para facilitar auditoria/custos
  identifier = "${local.resource_prefix}-postgres"
}

# ----------------------------------------
# DB Subnet Group (obrigatório para RDS em rede privada)
# ----------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = "${local.identifier}-subnet-group"
  description = "Subnets privadas para RDS PostgreSQL (${local.identifier})"
  subnet_ids  = var.private_subnet_ids

  tags = merge(
    {
      Name        = "${local.identifier}-subnet-group"
      Project     = var.project_name
      Environment = var.environment
      Stack       = "03-data"
      Component   = "rds"
    },
    var.tags
  )
}

# ----------------------------------------
# RDS PostgreSQL
# ----------------------------------------
resource "aws_db_instance" "this" {
  identifier = local.identifier

  engine         = "postgres"
  engine_version = "16.8" # pode ajustar depois (conforme política da empresa)

  instance_class = var.db_instance_class

  allocated_storage     = var.allocated_storage_gb
  max_allocated_storage = var.max_allocated_storage_gb

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Rede e segurança
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.database_security_group_id]
  publicly_accessible    = false

  # Produção / governança
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_days
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  storage_encrypted       = true

  # Mantém padrão: sem mexer em schema automaticamente
  # (migrations devem ser feitas pela aplicação / pipeline)
  apply_immediately = true

  # Logs e observabilidade básica (pode evoluir depois)
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = merge(
    {
      Name        = local.identifier
      Project     = var.project_name
      Environment = var.environment
      Stack       = "03-data"
      Component   = "rds"
    },
    var.tags
  )
}
