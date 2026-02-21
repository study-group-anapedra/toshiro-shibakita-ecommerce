/*
  eip.tf

  Este arquivo cria os Elastic IPs (EIP) que serão
  utilizados pelos NAT Gateways.

  O que é um Elastic IP?
  → É um IP público estático da AWS.
  → Ele garante que o NAT Gateway tenha um endereço fixo
    para saída da internet.

  Arquitetura adotada (padrão profissional):

  ✔ 2 AZs
  ✔ 1 NAT por AZ
  ✔ 1 EIP por NAT
  ✔ Uso de for_each com mapa estável (local.az_map)

  Observação importante:
  - O EIP é criado independentemente do NAT.
  - Depois, no nat.tf, usaremos:
      allocation_id = aws_eip.nat[each.key].id
*/

resource "aws_eip" "nat" {

  /*
    Usamos o mesmo mapa estável das subnets:
      az1
      az2

    Isso garante que:
      aws_eip.nat["az1"]
      aws_eip.nat["az2"]

    Sempre correspondam corretamente ao NAT da mesma AZ.
  */
  for_each = local.az_map

  # Indica que o EIP será usado dentro de uma VPC
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eip-${each.key}"
      Tier = "public"
    }
  )
}

