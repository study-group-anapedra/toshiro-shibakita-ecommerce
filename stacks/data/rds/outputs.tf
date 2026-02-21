/*
  outputs.tf (03-data/rds)

  Objetivo:
  - Expor apenas o necessário para conexão.
  - Não expor segredos.

  Quem consome isso?
  - main.tf da 03-data (output “agregado”)
  - outras stacks via remote_state (compute/eks/apps)
*/

output "endpoint" {
  description = "Endpoint do PostgreSQL (hostname)."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Porta do PostgreSQL."
  value       = aws_db_instance.this.port
}

output "identifier" {
  description = "Identifier do RDS (padrão do recurso)."
  value       = aws_db_instance.this.identifier
}

output "db_name" {
  description = "Nome do database inicial."
  value       = aws_db_instance.this.db_name
}
