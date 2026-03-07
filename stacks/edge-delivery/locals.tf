/*
  locals.tf (stack 06-edge-delivery)

  OBJETIVO:
  Centralizar convenções locais de nomenclatura desta stack.

  CORREÇÃO APLICADA:
  - Removidas referências herdadas da stack 04-compute-eks
  - Esta stack não cria cluster EKS nem lista de microsserviços
  - Mantido apenas o que faz sentido para a camada de entrega
*/

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}