/*
  locals.tf (stack 09-governance)

  Centraliza nomes padronizados e configurações reutilizáveis
  da stack de governança.
*/

locals {
  audit_retention_days = 90

  trail_name       = "${var.project_name}-${var.environment}-main-trail"
  audit_bucket_name = "${var.project_name}-${var.environment}-audit-logs-global"
}