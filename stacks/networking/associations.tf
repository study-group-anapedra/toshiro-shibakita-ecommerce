/*
  associations.tf

  Este arquivo associa cada subnet à Route Table correta.

  Sem associações:
  - A subnet não “sabe” qual tabela de rotas usar
  - Subnets públicas não saem pelo IGW
  - Subnets privadas não saem pelo NAT da própria AZ

  Padrão adotado:
   Subnets públicas  -> Route Table pública (única)
   Subnets privadas  -> Route Table privada da mesma AZ (az1/az2)
*/

# =========================================================
# Associações das Subnets Públicas -> RT Pública (1 única)
# =========================================================
resource "aws_route_table_association" "public" {
  /*
    Para cada subnet pública:
      aws_subnet.public["az1"]
      aws_subnet.public["az2"]
    associa com:
      aws_route_table.public (única)
  */
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# =========================================================
# Associações das Subnets Privadas -> RT Privada por AZ
# =========================================================
resource "aws_route_table_association" "private" {
  /*
    Para cada subnet privada:
      aws_subnet.private["az1"]
      aws_subnet.private["az2"]
    associa com a RT privada correspondente:
      aws_route_table.private["az1"]
      aws_route_table.private["az2"]
  */
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
