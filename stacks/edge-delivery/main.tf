/*
  main.tf (stack 06-edge-delivery)

  OBJETIVO:
  Criar a camada de entrega do frontend estático baseada em S3.

  PAPEL NA ARQUITETURA:
  - Provisiona o bucket onde o frontend será publicado
  - Impede acesso público direto indevido
  - Habilita versionamento
  - Habilita criptografia server-side
  - Define ownership control para evitar conflitos de ACL

  RELAÇÃO COM OUTRAS STACKS:
  - Usa as variáveis comuns do projeto/ambiente
  - Pode futuramente conversar com 07-dns-global e com um certificado ACM
    caso a borda evolua para CloudFront ou outro componente HTTPS

  RECURSOS AWS CONSUMIDOS:
  - aws_s3_bucket
  - aws_s3_bucket_public_access_block
  - aws_s3_bucket_versioning
  - aws_s3_bucket_server_side_encryption_configuration
  - aws_s3_bucket_ownership_controls

  RELEVÂNCIA:
  - Organiza a entrega do frontend de forma segura
  - Mantém a separação entre frontend estático e runtime do Kubernetes
  - Prepara a base para evolução futura sem acoplar a stack ao certificado
*/

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${var.environment}-frontend-site"

  # Em dev permite destruir o bucket com conteúdo;
  # em prod exige esvaziar antes para maior segurança operacional.
  force_destroy = var.environment == "dev"

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}