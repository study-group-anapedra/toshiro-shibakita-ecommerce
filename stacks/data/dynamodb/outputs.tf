/*
  outputs.tf (03-data/dynamodb)

  Exporta:
  - nomes das tabelas criadas
  - (útil para apps/pipelines consumirem via remote_state)
*/

output "table_names" {
  description = "Mapa: dominio -> nome da tabela DynamoDB."
  value       = { for d, t in aws_dynamodb_table.domain : d => t.name }
}
