/*
  main.tf (stack security)

  Esta stack cria a camada base de seguranca da infra.

  Objetivo:
  - Criar Security Groups padronizados
  - Centralizar regras de comunicacao
  - Usar a VPC vinda do remote_state (01-networking)

  Observacao:
  - Nao criamos bancos aqui.
  - Apenas definimos quem pode falar com quem.
*/

locals {
  # VPC vem da stack 01-networking via remote_state
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}

# =========================================
# SG ALB (internet -> ALB)
# =========================================
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-sg-alb"
  description = "ALB public entry HTTP HTTPS"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTP from internet optional redirect"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg-alb"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "edge"
  }
}

# =========================================
# SG APPS (ALB -> Apps/EKS)
# =========================================
resource "aws_security_group" "apps" {
  name        = "${var.project_name}-${var.environment}-sg-apps"
  description = "Application workloads EKS nodes"
  vpc_id      = local.vpc_id

  ingress {
    description     = "From ALB to apps"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg-apps"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "application"
  }
}

# =========================================
# SG RDS (Apps -> PostgreSQL)
# =========================================
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-sg-rds"
  description = "RDS PostgreSQL access from apps"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Postgres from apps"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.apps.id]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg-rds"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "data"
  }
}

# =========================================
# SG REDIS (Apps -> Redis)
# =========================================
resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-sg-redis"
  description = "ElastiCache Redis access from apps"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Redis from apps"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.apps.id]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg-redis"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "cache"
  }
}
