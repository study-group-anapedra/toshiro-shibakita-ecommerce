/*
  main.tf (03-data/dynamodb)

  O que cria:
  - 1 tabela DynamoDB por domínio (for_each)
  - Modelo genérico PK/SK:
      pk (string) + sk (string)
    Isso é flexível e serve para muitos padrões (event store, idempotência, locks, etc).

  Importante:
  - DynamoDB não depende de VPC/Subnets/SG.
  - Governança vem de tags e padrão de nomes.
*/

locals {
  resource_prefix = "${var.environment}-${var.project_name}"
}

resource "aws_dynamodb_table" "domain" {
  for_each = toset(var.domains)

  name         = "${var.dynamodb_prefix}-${each.key}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  # TTL (útil para idempotência, locks, tokens temporários, etc)
  dynamic "ttl" {
    for_each = var.enable_ttl ? [1] : []
    content {
      attribute_name = "ttl"
      enabled        = true
    }
  }

  # Backup contínuo (ponto no tempo)
  point_in_time_recovery {
    enabled = var.enable_pitr
  }

  tags = merge(
    {
      Name        = "${var.dynamodb_prefix}-${each.key}"
      Project     = var.project_name
      Environment = var.environment
      Stack       = "03-data"
      Component   = "dynamodb"
      Domain      = each.key
      ManagedBy   = "terraform"
    },
    var.tags
  )
}
