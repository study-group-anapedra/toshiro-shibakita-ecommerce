/*
  main.tf - 00-bootstrap

  Este stack cria o backend remoto do Terraform:

  - Bucket S3 para armazenar o state
  - Tabela DynamoDB para lock

  Ele NÃO usa backend remoto.
  Ele é o bootstrap inicial.
*/

# ---------------------------------------------------------
# S3 Bucket para armazenar o Terraform State
# ---------------------------------------------------------

resource "aws_s3_bucket" "tfstate" {
  bucket = var.remote_backend_bucket_name

  force_destroy = false

  tags = merge(
    var.tags,
    {
      Name = var.remote_backend_bucket_name
    }
  )
}

# ---------------------------------------------------------
# Versionamento do Bucket (obrigatório em produção)
# ---------------------------------------------------------

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------------------------------------------------
# Criptografia do Bucket
# ---------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------------------------
# DynamoDB Table para Lock do Terraform
# ---------------------------------------------------------

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = var.remote_backend_dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = var.remote_backend_dynamodb_table
    }
  )
}

