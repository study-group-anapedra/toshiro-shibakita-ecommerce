/*
  nat.tf

  Este arquivo cria os NAT Gateways (1 por AZ).

  O que é NAT Gateway?
  → Permite que recursos em subnets PRIVADAS saiam para a internet
    sem terem IP público e sem receberem tráfego de entrada da internet.

  Arquitetura adotada (padrão enterprise):

  ✔ 2 AZs
  ✔ 1 NAT por AZ
  ✔ NAT fica dentro de subnet pública
  ✔ Cada NAT usa um Elastic IP (EIP) dedicado
  ✔ Subnets privadas apontam rota 0.0.0.0/0 para o NAT da mesma AZ

  Importante:
  - O EIP NÃO é criado aqui (ele está em eip.tf)
  - Aqui apenas “liga” o NAT ao EIP e à subnet pública correta.
*/

resource "aws_nat_gateway" "nat" {

  /*
    Usamos o mesmo mapa estável (local.az_map)
    para garantir chaves consistentes:

      aws_nat_gateway.nat["az1"]
      aws_nat_gateway.nat["az2"]
  */
  for_each = local.az_map

  /*
    allocation_id:
    - “Conecta” este NAT ao Elastic IP correspondente.
    - O índice [each.key] garante que:
        az1 -> eip az1
        az2 -> eip az2
  */
  allocation_id = aws_eip.nat[each.key].id

  /*
    subnet_id:
    - NAT precisa estar em subnet pública
    - Pegamos a subnet pública da mesma AZ (az1/az2)
  */
  subnet_id = aws_subnet.public[each.key].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-${each.key}"
      Tier = "public"
    }
  )

  /*
    Dependência explícita:
    - Garante que o IGW já exista antes do NAT.
    - Mesmo que o Terraform “saiba” por referências indiretas,
      manter isso evita edge-cases de ordem em algumas contas/regiões.
  */
  depends_on = [aws_internet_gateway.main]
}

