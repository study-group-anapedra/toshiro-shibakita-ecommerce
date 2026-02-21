/*
  locals.tf (stack 08-governance)
  DIDÁTICA: Define regras de retenção e nomes padronizados.
*/

locals {
  # Tempo que os logs de auditoria ficarão guardados antes de serem apagados
  audit_retention_days = 90 

  # Nome amigável para a trilha de auditoria
  trail_name = "${var.project_name}-${var.environment}-main-audit"
}