/*
  main.tf (stack 06-edge-delivery)

  OBJETIVO:
  Criar a camada de entrega do frontend estático.

  CONTEXTO:
  - Esta stack cuida do bucket S3 do frontend.
  - O ALB não é criado aqui.
  - Em arquitetura com EKS, o balanceador HTTP/HTTPS tende a ser criado
    dinamicamente pelo AWS Load Balancer Controller a partir de recursos Ingress.

  BENEFÍCIOS:
  - Separação clara entre infraestrutura base e runtime do Kubernetes
  - Menor acoplamento
  - Mais aderência ao fluxo moderno com EKS
*/

##################################################
# S3 - FRONTEND ESTÁTICO
##################################################

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${var.environment}-frontend-site"

  # Em dev permite destruir o bucket com conteúdo;
  # em prod, exige esvaziar antes para maior segurança.
  force_destroy = var.environment == "dev"

  tags = var.tags
}

##################################################
# BLOQUEIO DE ACESSO PÚBLICO DIRETO
##################################################

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##################################################
# VERSIONAMENTO
##################################################

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

##################################################
# CRIPTOGRAFIA SERVER SIDE
##################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################################
# CONTROLE DE PROPRIEDADE DOS OBJETOS
##################################################

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}