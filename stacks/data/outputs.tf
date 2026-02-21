/*
  outputs.tf (stack 03-data)

  Responsabilidade:

  Exportar informações da camada DATA
  para outras stacks da arquitetura.

  Exemplo:

  04-compute-eks
  api-gateway
  workers
  CI/CD pipelines

  NÃO expomos senha ou segredo aqui.

  Apenas endpoints e nomes necessários
  para conexão segura.

*/


# =====================================================
# PostgreSQL (RDS)
# =====================================================

output "postgres_endpoint" {

  description = "Endpoint do PostgreSQL (RDS) usado pelos domínios."

  value = try(
    module.rds[0].endpoint,
    null
  )
}



output "postgres_port" {

  description = "Porta do PostgreSQL."

  value = try(
    module.rds[0].port,
    null
  )
}



# =====================================================
# REDIS (ELASTICACHE)
# =====================================================

output "redis_primary_endpoint" {

  description = "Endpoint primário Redis usado para cache e sessão."

  value = try(
    module.elasticache[0].primary_endpoint,
    null
  )
}



output "redis_reader_endpoint" {

  description = "Endpoint reader Redis (se existir)."

  value = try(
    module.elasticache[0].reader_endpoint,
    null
  )
}



# =====================================================
# DYNAMODB
# =====================================================

output "dynamodb_tables" {

  description = "Tabelas DynamoDB criadas para os domínios."

  value = try(
    module.dynamodb[0].table_names,
    []
  )
}
