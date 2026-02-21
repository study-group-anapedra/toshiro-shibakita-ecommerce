/*
  main.tf (stack 08-governance)
  DIDÁTICA: Configura o CloudTrail para monitorar todas as APIs da conta AWS.
*/

# 1. Bucket S3 para os Logs de Auditoria (A 'caixa-preta' do sistema)
resource "aws_s3_bucket" "audit_logs" {
  bucket        = "${var.project_name}-${var.environment}-audit-logs-global"
  force_destroy = true # Em Dev, permite apagar o bucket com logs para facilitar testes.
  
  tags = var.tags
}

# 2. Bloqueio de Acesso Público (Segurança Crítica)
resource "aws_s3_bucket_public_access_block" "audit_logs_block" {
  bucket = aws_s3_bucket.audit_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Configuração do CloudTrail
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-${var.environment}-main-trail"
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true # Monitora ações em todas as regiões da AWS.
  enable_log_file_validation    = true # Garante que ninguém alterou os logs.

  tags = var.tags
}