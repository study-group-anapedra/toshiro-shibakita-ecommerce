/*
  outputs.tf

  Outputs são os “valores públicos” desta stack.
  As stacks seguintes (03-data, 05-edge...) vão consumir isso via remote_state.

  Aqui exportamos os Security Group IDs que acabamos de criar.
*/

output "sg_alb_id" {
  description = "Security Group do ALB"
  value       = aws_security_group.alb.id
}

output "sg_apps_id" {
  description = "Security Group das aplicações (EKS/nodes/apps)"
  value       = aws_security_group.apps.id
}

output "sg_rds_id" {
  description = "Security Group do RDS (Postgres)"
  value       = aws_security_group.rds.id
}

output "sg_redis_id" {
  description = "Security Group do Redis (ElastiCache)"
  value       = aws_security_group.redis.id
}
