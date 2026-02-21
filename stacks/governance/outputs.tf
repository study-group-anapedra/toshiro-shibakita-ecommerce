/*
  main.tf (stack 08-governance)
  FUNÇÃO: Ativar auditoria global para segurança da plataforma.
*/

# 1. Bucket S3 para armazenar os registros de auditoria (A 'caixa-preta')
resource "aws_s3_bucket" "audit_logs" {
  bucket        = "${var.project_name}-${var.environment}-audit-logs-trail"
  force_destroy = true # Em Dev, permite apagar o bucket mesmo com logs
  
  tags = var.tags
}

# 2. Configuração do CloudTrail
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-${var.environment}-main-trail"
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true # Monitora ações em todas as regiões AWS
  enable_log_file_validation    = true # Garante a integridade dos logs
  
  tags = var.tags
}