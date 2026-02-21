# outputs.tf
# -------------------------------------------------------------------
# Este arquivo exporta informações importantes do bootstrap,
# permitindo visualizar e reutilizar os valores criados.
# -------------------------------------------------------------------

# Nome do bucket S3 do Terraform state
output "tfstate_bucket_name" {
  description = "Nome do bucket S3 onde o Terraform state é armazenado"
  value       = aws_s3_bucket.tfstate.bucket
}

# ARN do bucket S3
output "tfstate_bucket_arn" {
  description = "ARN do bucket S3 do Terraform state"
  value       = aws_s3_bucket.tfstate.arn
}

# Nome da tabela DynamoDB de lock
output "tfstate_lock_table_name" {
  description = "Nome da tabela DynamoDB usada para lock do state"
  value       = aws_dynamodb_table.tfstate_lock.name
}

# ARN da tabela DynamoDB
output "tfstate_lock_table_arn" {
  description = "ARN da tabela DynamoDB usada para lock do state"
  value       = aws_dynamodb_table.tfstate_lock.arn
}
