/*
  outputs.tf (stack 08-observability)

  Exporta informações úteis da stack para conferência e integrações futuras.
*/

output "cluster_log_group_name" {
  description = "Nome do log group principal do cluster EKS."
  value       = aws_cloudwatch_log_group.eks_cluster.name
}

output "application_log_group_names" {
  description = "Nomes dos log groups das aplicações."
  value       = [for lg in aws_cloudwatch_log_group.apps : lg.name]
}

output "dashboard_name" {
  description = "Nome do dashboard principal do CloudWatch."
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}