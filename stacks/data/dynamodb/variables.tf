/*
  variables.tf (03-data/dynamodb)

  Objetivo:
  - Declarar as entradas para criar DynamoDB de forma padronizada.

  Estratégia enterprise simples:
  - 1 tabela por domínio que precisa DynamoDB
  - Naming consistente por ambiente/projeto
  - PAY_PER_REQUEST (evita dor de cabeça e custo previsível no começo)
*/

variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Ambiente (dev/staging/prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "dynamodb_prefix" {
  description = "Prefixo base para nomes das tabelas (ex: dev-toshiro-ecommerce-ddb)."
  type        = string
}

variable "domains" {
  description = "Lista de domínios que precisam de tabela DynamoDB."
  type        = list(string)
  default     = []
}

variable "enable_pitr" {
  description = "Point-in-time recovery (recomendado true em prod)."
  type        = bool
  default     = true
}

variable "enable_ttl" {
  description = "Habilita TTL (atributo: ttl)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags extras opcionais."
  type        = map(string)
  default     = {}
}
