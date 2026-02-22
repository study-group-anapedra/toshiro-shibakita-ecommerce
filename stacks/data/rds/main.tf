/*
  main.tf (03-data/rds)
  
  O QUE FAZ:
  1. Gera uma senha randômica forte.
  2. Cria um cofre no AWS Secrets Manager para guardar essa senha.
  3. Cria o banco de dados RDS usando essa senha gerada.

  RELEVÂNCIA:
  Segurança máxima. A senha nunca aparece no log do GitHub Actions e 
  você não precisa digitar nada no terminal (resolve o erro de prompt de senha).
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"
  identifier      = "${local.resource_prefix}-postgres"
}

# -------------------------------------------------------------------------------
# GESTÃO AUTOMÁTICA DE SENHA (AWS Secrets Manager)
# -------------------------------------------------------------------------------

# Gera uma string aleatória para ser a senha
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Cria o "Cofre" na AWS para guardar a senha
resource "aws_secretsmanager_secret" "db_password" {
  name        = "${local.identifier}-password-v2" # Nome único do segredo
  description = "Senha master do RDS PostgreSQL gerada automaticamente"
  tags        = var.tags
}

# Salva o valor da senha dentro do Cofre
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

# -------------------------------------------------------------------------------
# RDS POSTGRESQL
# -------------------------------------------------------------------------------

resource "aws_db_subnet_group" "this" {
  name        = "${local.identifier}-subnet-group"
  subnet_ids  = var.private_subnet_ids
  tags        = var.tags
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
  
  # SENHA: Pega o resultado da geração randômica acima
  password = random_password.db_password.result

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