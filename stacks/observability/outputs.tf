/*
  outputs.tf (stack 08-observability)

  Exporta informações úteis da stack para conferência e integrações futuras.

  IMPORTANTE
  O output do log group principal do cluster EKS foi removido porque
  o recurso aws_cloudwatch_log_group.eks_cluster não existe mais nesta stack.
  O EKS pode criar esse log group automaticamente, então manter referência
  a ele aqui causaria erro de "Reference to undeclared resource".
*/

output "application_log_group_names" {
  description = "Nomes dos log groups das aplicações."
  value       = [for lg in aws_cloudwatch_log_group.apps : lg.name]
}

output "dashboard_name" {
  description = "Nome do dashboard principal do CloudWatch."
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}