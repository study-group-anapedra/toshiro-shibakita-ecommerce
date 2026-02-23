/*
  main.tf (03-data/rds)

  O que faz:
  - Cria um RDS PostgreSQL.
  - A senha do master user é gerenciada automaticamente pela AWS:
      manage_master_user_password = true
    Isso cria/usa um Secret no AWS Secrets Manager automaticamente.

  Quem consome:
  - outputs.tf do módulo (endpoint/port/db_name/secret_arn)
  - stacks/apps/compute depois (via remote_state) para conectar no banco

  Relevância:
  - Zero senha no Terraform, zero prompt no GitHub Actions.
  - Padrão seguro e pronto pra produção.
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"
  identifier      = "${local.resource_prefix}-postgres"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "this" {
  identifier     = local.identifier
  engine         = "postgres"
  engine_version = "16.3"
  instance_class = var.db_instance_class

  allocated_storage     = var.allocated_storage_gb
  max_allocated_storage = var.max_allocated_storage_gb

  db_name  = var.db_name
  username = var.db_username

  #AWS cria/gerencia automaticamente a senha no Secrets Manager
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.database_security_group_id]
  publicly_accessible    = false

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_days
  storage_encrypted       = true
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  tags = var.tags
}