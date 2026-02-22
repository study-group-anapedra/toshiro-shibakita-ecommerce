/*
  stacks/data/rds/main.tf

  O QUE É:
  - Módulo/stack responsável por criar o RDS PostgreSQL (a “camada de dados”).

  O QUE FAZ (na prática):
  1) Cria um DB Subnet Group (RDS precisa saber em quais subnets privadas ficar).
  2) Cria a instância RDS PostgreSQL dentro da VPC privada.
  3) Habilita senha gerenciada automaticamente pela AWS:
     - manage_master_user_password = true
     - A AWS guarda/rotaciona a senha no AWS Secrets Manager

  COM QUEM CONVERSA:
  - Recebe:
    * private_subnet_ids (da stack networking via remote_state)
    * database_security_group_id (da stack security via remote_state)
  - “Entrega”:
    * um banco RDS pronto e seguro, sem senha hardcoded no Terraform.

  RELEVÂNCIA:
  - Segurança real de produção:
    * sem senha em tfvars
    * sem senha no GitHub Actions
    * senha centralizada e gerenciada no Secrets Manager
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"
  identifier      = "${local.resource_prefix}-postgres"

  /*
    Username:
    - A AWS NÃO escolhe username automaticamente.
    - Então:
      * se você passar db_username, usamos ele
      * se vier vazio, o Terraform gera um username seguro e previsível
  */
  effective_db_username = (
    trim(var.db_username) != ""
    ? var.db_username
    : "app_${random_pet.db_username_suffix.id}"
  )
}

# -------------------------------------------------------------------------------
# Username auto-gerado (quando db_username vier vazio)
# -------------------------------------------------------------------------------
resource "random_pet" "db_username_suffix" {
  length = 2
}

# -------------------------------------------------------------------------------
# DB Subnet Group (RDS em subnets privadas)
# -------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${local.identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

# -------------------------------------------------------------------------------
# RDS PostgreSQL
# -------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier     = local.identifier
  engine         = "postgres"
  engine_version = "16.3"
  instance_class = var.db_instance_class

  allocated_storage     = var.allocated_storage_gb
  max_allocated_storage = var.max_allocated_storage_gb

  db_name  = var.db_name
  username = local.effective_db_username

  /*
     SENHA 100% gerenciada pela AWS
    - A AWS cria e armazena a senha no Secrets Manager automaticamente.
    - Não existe "password =" aqui.
    - Isso elimina vazamento em log, tfvars, commits, etc.
  */
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