/*
  outputs.tf (03-data/rds)

  OBJETIVO
  --------
  Expor somente informações necessárias para conexão com o banco
  sem nunca expor senha ou segredo diretamente.

  QUEM USA ESTES OUTPUTS
  ----------------------
  ✔ Stack compute (EKS / EC2 / ECS)
  ✔ API Gateway / aplicações backend
  ✔ Outras stacks Terraform via terraform_remote_state

  SEGURANÇA
  ---------
  A senha NÃO aparece aqui.
  O RDS gerencia automaticamente no AWS Secrets Manager.

  O que expomos:
  - Endpoint
  - Porta
  - Nome DB
  - ARN do Secret (para apps lerem via IAM)
*/

# ---------------------------------------------------------
# Endpoint DNS do banco
# ---------------------------------------------------------
output "endpoint" {
  description = "Hostname de conexão PostgreSQL"
  value       = aws_db_instance.this.address
}

# ---------------------------------------------------------
# Porta do banco
# ---------------------------------------------------------
output "port" {
  description = "Porta PostgreSQL"
  value       = aws_db_instance.this.port
}

# ---------------------------------------------------------
# Identifier AWS do banco
# ---------------------------------------------------------
output "identifier" {
  description = "Identifier do RDS"
  value       = aws_db_instance.this.identifier
}

# ---------------------------------------------------------
# Nome do Database inicial
# ---------------------------------------------------------
output "db_name" {
  description = "Database inicial criado no RDS"
  value       = aws_db_instance.this.db_name
}

# ---------------------------------------------------------
#  SEGREDO GERENCIADO PELA AWS (IMPORTANTE)
# ---------------------------------------------------------
/*
  NÃO expõe senha.

  Apenas o ARN do Secret criado automaticamente
  pelo RDS quando manage_master_user_password = true.

  Sua aplicação usa esse ARN para buscar credenciais
  via IAM Role.
*/
output "master_user_secret_arn" {

  description = "ARN do Secret Manager contendo usuário e senha do RDS"

  value = aws_db_instance.this.master_user_secret[0].secret_arn
}