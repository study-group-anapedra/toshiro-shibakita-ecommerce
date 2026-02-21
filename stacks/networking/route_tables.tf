/*
  route_tables.tf

  Este arquivo cria as Route Tables (tabelas de rota) da VPC.

  Conceito:
  - Subnet = “onde os recursos ficam”
  - Route Table = “por onde o tráfego sai”

  Padrão profissional usado aqui:

   1 Route Table PÚBLICA (compartilhada)
     - Todas as subnets públicas usam a mesma RT
     - Rota 0.0.0.0/0 -> IGW (em routes.tf)

   1 Route Table PRIVADA por AZ (isolamento real)
     - Cada subnet privada usa a RT da sua própria AZ
     - Rota 0.0.0.0/0 -> NAT da mesma AZ (em routes.tf)

  Por que 1 privada por AZ?
  - Evita cross-AZ traffic (mais caro e menos eficiente)
  - Mantém o tráfego “local” na AZ
  - Dá alta disponibilidade real: se um NAT/AZ cair, a outra continua funcionando
*/

# =========================================================
# Route Table Pública (1 única para todas as subnets públicas)
# =========================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-public"
      Tier = "public"
    }
  )
}

# =========================================================
# Route Tables Privadas (1 por AZ)
# =========================================================
resource "aws_route_table" "private" {
  /*
    Usamos o mesmo mapa estável das AZs:

      aws_route_table.private["az1"]
      aws_route_table.private["az2"]

    Isso casa 1:1 com:
      - aws_subnet.private["az1"/"az2"]
      - aws_nat_gateway.nat["az1"/"az2"]
  */
  for_each = local.az_map

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-private-${each.key}"
      Tier = "private"
      AZ   = each.value
    }
  )
}
