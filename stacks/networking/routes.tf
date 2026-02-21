/*
  routes.tf

  Este arquivo cria as rotas de saída (0.0.0.0/0) das Route Tables.

  Conceito:

   Route Table Pública
     - usada pelas subnets públicas
     - rota default para o Internet Gateway (IGW)
       0.0.0.0/0 -> IGW

   Route Table Privada (1 por AZ)
     - usada pelas subnets privadas
     - rota default para o NAT da MESMA AZ
       0.0.0.0/0 -> NAT[az1] na RT privada[az1]
       0.0.0.0/0 -> NAT[az2] na RT privada[az2]

  Por que “NAT por AZ”?
  - Evita cross-AZ traffic (custo e latência)
  - Mantém isolamento e alta disponibilidade real
*/

# =========================================================
# ROTA DEFAULT DA INTERNET - SUBNETS PÚBLICAS
# (0.0.0.0/0 -> IGW)
# =========================================================
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.main.id
}

# =========================================================
# ROTAS DEFAULT DAS SUBNETS PRIVADAS (1 por AZ)
# (0.0.0.0/0 -> NAT da mesma AZ)
# =========================================================
resource "aws_route" "private_nat_access" {
  /*
    Cria 2 rotas (uma para cada AZ):
      - route_table.private["az1"] -> nat["az1"]
      - route_table.private["az2"] -> nat["az2"]
  */
  for_each = local.az_map

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.nat[each.key].id
}

