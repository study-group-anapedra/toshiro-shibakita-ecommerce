/*
  locals.tf (stack 04-compute-eks)
  DIDÁTICA: Define o nome do cluster e os serviços que ganharão ECR.
*/

locals {
  cluster_name = "${var.project_name}-${var.environment}-cluster"

  # Seus domínios conforme a tabela arquitetural
  services = [
    "catalog-service",
    "inventory-service",
    "order-service",
    "auth-service",
    "notification-service"
  ]
}