/*
  main.tf (stack 08-observability)

  DIDÁTICA
  Cria recursos básicos de observabilidade no CloudWatch:
  - log groups dos microsserviços
  - dashboard principal

  IMPORTANTE
  O log group /aws/eks/<cluster>/cluster não deve ser criado aqui,
  porque ele já pode ser criado automaticamente pelo EKS/control plane.
  Se o Terraform tentar criar esse mesmo recurso, ocorre conflito
  ResourceAlreadyExistsException.
*/

resource "aws_cloudwatch_log_group" "apps" {
  for_each          = toset(local.app_log_groups)
  name              = "/aws/eks/${local.cluster_name}/apps/${each.key}"
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 3
        properties = {
          markdown = "# Monitoramento ${var.project_name} (${var.environment})"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 3
        width  = 12
        height = 6
        properties = {
          title   = "EKS Cluster Insights"
          region  = var.aws_region
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["ContainerInsights", "node_cpu_utilization", "ClusterName", local.cluster_name],
            [".", "node_memory_utilization", ".", "."]
          ]
        }
      }
    ]
  })
}