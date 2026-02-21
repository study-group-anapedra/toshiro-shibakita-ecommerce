/*
  outputs.tf (03-data/elasticache)

  Exporta endpoints para a aplicação consumir via remote_state.
*/

output "primary_endpoint" {
  description = "Endpoint primário do Redis."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Endpoint reader do Redis (se existir)."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}
