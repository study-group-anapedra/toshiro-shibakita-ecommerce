/*
  locals.tf (stack 04-compute-eks)
  FUNÇÃO: Centralizar a lista de domínios (microsserviços).
  POR QUE: Para não repetir código; se adicionar um serviço aqui, ele ganha ECR e Roles de IAM.
*/

locals {
  services = [
    "catalog-service",
    "inventory-service",
    "order-service",
    "auth-service",
    "notification-service"
  ]

  cluster_name = "${var.project_name}-${var.environment}-cluster"
}