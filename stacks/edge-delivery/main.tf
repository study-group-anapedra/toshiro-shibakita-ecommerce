/*
  main.tf (stack 05-edge-delivery)

  Esta stack representa a camada de entrega (edge) responsável
  pelo frontend estático da aplicação.

  O Application Load Balancer não é  criado aqui porque,
  em arquiteturas modernas com Kubernetes (EKS), o balanceador
  passa a ser provisionado automaticamente pelo AWS Load
  Balancer Controller através de recursos Ingress.

  Dessa forma:

  - Terraform continua responsável pela infraestrutura base
    (armazenamento, rede e segurança).

  - Kubernetes passa a controlar dinamicamente o tráfego HTTP/HTTPS,
    criando ALB, listeners e target groups conforme os serviços
    publicados no cluster.

  Isso elimina manutenção manual, acompanha autoscaling de pods
  e reduz inconsistências entre infraestrutura e runtime.
*/


##################################################
# S3 - FRONTEND ESTÁTICO
##################################################

resource "aws_s3_bucket" "frontend" {

  # Nome globalmente único no S3
  bucket = "${var.project_name}-${var.environment}-frontend-site"

  # Em ambiente dev permite destruir bucket mesmo contendo arquivos
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
# VERSIONAMENTO (RECUPERAÇÃO DE ARQUIVOS)
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

      # Criptografia padrão AWS (AES256)
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
    # Garante que somente o dono do bucket controla objetos enviados
    object_ownership = "BucketOwnerEnforced"
  }
}