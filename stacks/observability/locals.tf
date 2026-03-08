/*
  locals.tf (stack 08-observability)

  Centraliza valores derivados dos states remotos e convenções locais.
*/

locals {
  cluster_name = try(
    data.terraform_remote_state.compute.outputs.cluster_name,
    "${var.project_name}-${var.environment}-cluster"
  )

  app_log_groups = [
    "auth-service",
    "order-service",
    "catalog-service",
    "inventory-service"
  ]
}