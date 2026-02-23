/*
  outputs.tf (03-data/rds)

  Objetivo:
  - Expor apenas o necessário para conexão.
  - Não expor a senha.
  - Expor o ARN do Secret gerenciado pela AWS para que a aplicação leia a senha com IAM.

  Quem consome:
  - stack 03-data (agregação)
  - stacks futuras (compute/apps) via remote_state
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
  description = "Identifier do RDS."
  value       = aws_db_instance.this.identifier
}

output "db_name" {
  description = "Nome do database inicial."
  value       = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "ARN do Secret (AWS-managed) com as credenciais do master user."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}