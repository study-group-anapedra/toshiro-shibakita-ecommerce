/*
  stacks/edge-delivery/outputs.tf

  FUNÇÃO:
  Exportar o DNS e o ARN do Load Balancer para serem usados no Route53 (DNS Global).
*/

output "alb_dns_name" {
  description = "DNS público do Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN do Load Balancer para políticas de segurança e monitoramento"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID do Load Balancer para o Alias Record no Route53"
  value       = aws_lb.main.zone_id
}