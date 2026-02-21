/*
  subnets.tf

  Este arquivo cria as subnets da VPC.

  Estratégia arquitetural (padrão profissional):

  - 2 AZs (Alta Disponibilidade real)
  - 2 Subnets Públicas (1 por AZ) → ALB + NAT Gateway (sem Bastion; acesso administrativo via SSM)
  - 2 Subnets Privadas (1 por AZ) → EC2/ECS/EKS Nodes/RDS (dependendo do desenho)

  Observação importante:
  - Subnet pública = tem rota 0.0.0.0/0 para o IGW (feito nas route tables)
  - Subnet privada = tem rota 0.0.0.0/0 para o NAT (feito nas route tables)
  - Aqui nós SÓ criamos as subnets (a “geografia”); rotas vêm depois.
*/

# =========================================================
# Subnets Públicas (1 por AZ)
# =========================================================
resource "aws_subnet" "public" {
  /*
    Usamos o mapa estável (local.az_map):
      az1 = "us-east-1a"
      az2 = "us-east-1b"

    Isso garante consistência: todos os recursos que dependem de AZ
    usam as mesmas chaves ("az1", "az2") e evita misturar padrões.
  */
  for_each = local.az_map

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value

  /*
    CIDR das subnets:

    cidrsubnet(base, newbits, netnum)

    - base    = var.vpc_cidr (ex: 10.0.0.0/16)
    - newbits = 4  -> divide /16 em /20 (pois 16+4 = /20)
    - netnum  = índice do bloco que você quer

    Aqui adotamos um esquema simples e previsível:

    Públicas:
      az1 -> netnum 0  => 10.0.0.0/20
      az2 -> netnum 1  => 10.0.16.0/20

    Privadas:
      az1 -> netnum 10 => 10.0.160.0/20
      az2 -> netnum 11 => 10.0.176.0/20

    Por que separar “0/1” das “10/11”?
    - Evita colisões
    - Fica fácil crescer depois
    - Mantém um “espaço” para subnets futuras
  */
  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    each.key == "az1" ? 0 : 1
  )

  /*
    Subnet pública: instâncias podem receber IP público automaticamente.
    (Quem decide se vai ser “pública de verdade” é a route table + IGW,
     mas isso aqui é a configuração típica e correta.)
  */
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-${each.key}" # ex: toshiro-ecommerce-dev-public-az1
    Tier = "public"
    AZ   = each.value
  })
}

# =========================================================
# Subnets Privadas (1 por AZ)
# =========================================================
resource "aws_subnet" "private" {
  for_each = local.az_map

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value

  /*
    Privadas usam outros blocos (10 e 11) para não conflitar com as públicas.
  */
  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    each.key == "az1" ? 10 : 11
  )

  /*
    Subnet privada: NÃO habilitamos IP público automático.
    O acesso à internet será via NAT Gateway (rota 0.0.0.0/0 para NAT),
    que será criado por AZ, com EIP por NAT.
  */
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-${each.key}" # ex: toshiro-ecommerce-dev-private-az1
    Tier = "private"
    AZ   = each.value
  })
}
