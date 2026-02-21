/*
  outputs.tf

  Este arquivo exporta informações da stack de networking
  para que outras stacks (ex: compute, rds, eks) possam consumir
  via remote_state.

  Padrão aplicado:
  ✔ Compatível com for_each (az1/az2)
  ✔ Evita hardcode de recursos individuais
  ✔ Retorna listas e mapas quando apropriado
  ✔ Pronto para multi-AZ escalável
*/

# =========================================================
# VPC
# =========================================================
output "vpc_id" {
  description = "ID da VPC principal"
  value       = aws_vpc.main.id
}

# =========================================================
# Subnets Públicas (lista ordenada)
# =========================================================
output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = values(aws_subnet.public)[*].id
}

# =========================================================
# Subnets Privadas (lista ordenada)
# =========================================================
output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = values(aws_subnet.private)[*].id
}

# =========================================================
# Subnets Públicas (mapa por AZ)
# Útil quando você precisa saber exatamente qual subnet é az1/az2
# =========================================================
output "public_subnets_by_az" {
  description = "Mapa das subnets públicas por AZ (az1, az2)"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

# =========================================================
# Subnets Privadas (mapa por AZ)
# =========================================================
output "private_subnets_by_az" {
  description = "Mapa das subnets privadas por AZ (az1, az2)"
  value       = { for k, v in aws_subnet.private : k => v.id }
}

# =========================================================
# NAT Gateways
# =========================================================
output "nat_gateway_ids" {
  description = "Lista de IDs dos NAT Gateways"
  value       = values(aws_nat_gateway.nat)[*].id
}

# =========================================================
# Route Tables
# =========================================================
output "public_route_table_id" {
  description = "ID da Route Table pública"
  value       = aws_route_table.public.id
}

output "private_route_tables_by_az" {
  description = "Mapa das Route Tables privadas por AZ"
  value       = { for k, v in aws_route_table.private : k => v.id }
}
