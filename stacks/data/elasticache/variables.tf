/*
  variables.tf (03-data/elasticache)

  Objetivo:
  - Declarar entradas para criar Redis (ElastiCache) em rede privada.

  Estratégia:
  - 1 cluster/replication-group compartilhado para domínios que usam Redis
  - Subnet Group privado + Security Group (porta 6379 controlada)
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

variable "private_subnet_ids" {
  description = "Subnets privadas para o ElastiCache Subnet Group."
  type        = list(string)
}

variable "redis_security_group_id" {
  description = "Security Group do Redis (porta 6379 liberada apenas do sg_apps)."
  type        = string
}

variable "redis_cluster_name" {
  description = "Nome base do cluster (ex: dev-toshiro-ecommerce-redis)."
  type        = string
}

variable "node_type" {
  description = "Tipo do nó (dev: menor; prod: maior)."
  type        = string
  default     = "cache.t4g.micro"
}

variable "engine_version" {
  description = "Versão do Redis."
  type        = string
  default     = "7.1"
}

variable "multi_az" {
  description = "Alta disponibilidade (prod geralmente true)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags extras opcionais."
  type        = map(string)
  default     = {}
}
