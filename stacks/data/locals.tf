/*
  locals.tf (stack data)

  Este arquivo centraliza decisões arquiteturais da camada DATA.

  Aqui definimos:

  ✔ Convenções de nomes.
  ✔ Prefixos de recursos.
  ✔ Quais domínios utilizam quais bancos.

  O main.tf NÃO decide nada.
  Ele apenas lê este mapa.

  Isso permite:

  - Adicionar novos serviços facilmente.
  - Migrar bancos sem reescrever módulos.
  - Governança enterprise.

*/

locals {

  # =====================================================
  # Prefixo padrão
  # =====================================================

  resource_prefix = "${var.environment}-${var.project_name}"

  # =====================================================
  # Identificadores dos bancos
  # =====================================================

  postgres_identifier = "${local.resource_prefix}-postgres"

  redis_cluster_name = "${local.resource_prefix}-redis"

  dynamodb_prefix = "${local.resource_prefix}-ddb"

  # =====================================================
  # MAPA CENTRAL DOS DOMÍNIOS
  # =====================================================
  /*
    true  = usa o banco
    false = não usa

    Ajustar aqui muda toda arquitetura.
  */

  domain_databases = {

    # ---------------------------------
    # CATÁLOGO
    # ---------------------------------

    catalog-service = {
      postgres = true
      redis    = true
      dynamodb = false
    }

    # ---------------------------------
    # INVENTORY (source of truth)
    # ---------------------------------

    inventory-service = {
      postgres = true
      redis    = true
      dynamodb = false
    }

    # ---------------------------------
    # ORDERS (event driven)
    # ---------------------------------

    order-service = {
      postgres = true
      redis    = false
      dynamodb = true
    }

    # ---------------------------------
    # AUTH
    # ---------------------------------

    auth-service = {
      postgres = false
      redis    = true
      dynamodb = true
    }

    # ---------------------------------
    # API GATEWAY (opcional)
    # Cache tokens/rate limit.
    # ---------------------------------

    api-gateway = {
      postgres = false
      redis    = true
      dynamodb = false
    }

    # ---------------------------------
    # NOTIFICATION SERVICE
    # Async workers / idempotência
    # ---------------------------------

    notification-service = {
      postgres = false
      redis    = true
      dynamodb = true
    }

  }

  # =====================================================
  # LISTAS DERIVADAS AUTOMÁTICAS
  # =====================================================
  /*
    Terraform vai usar isso depois
    para criar recursos automaticamente.
  */

  postgres_domains = [
    for name, cfg in local.domain_databases :
    name if cfg.postgres
  ]

  redis_domains = [
    for name, cfg in local.domain_databases :
    name if cfg.redis
  ]

  dynamodb_domains = [
    for name, cfg in local.domain_databases :
    name if cfg.dynamodb
  ]

}
