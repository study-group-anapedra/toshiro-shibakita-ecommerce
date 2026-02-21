/*
  main.tf (stack 07-observability)
  DIDÁTICA: Cria os recursos do CloudWatch para logs centralizados e dashboards.
*/

# 1. Grupo de Logs centralizado para o Cluster EKS
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7 # Economia de custo: logs são apagados após 7 dias em Dev.

  tags = var.tags
}

# 2. Log Groups específicos para os Microsserviços (Spring Boot / Go)
resource "aws_cloudwatch_log_group" "apps" {
  for_each          = toset(["auth-service", "order-service", "catalog-service"])
  name              = "/aws/eks/${local.cluster_name}/apps/${each.key}"
  retention_in_days = 7

  tags = var.tags
}

# 3. Dashboard Centralizado da Plataforma
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
          markdown = "# 📊 Monitoramento Toshiro-Shibakita (${var.environment})"
        }
      }
      # Aqui você pode adicionar widgets de métricas de CPU, Memória e Erros 4xx/5xx
    ]
  })
}