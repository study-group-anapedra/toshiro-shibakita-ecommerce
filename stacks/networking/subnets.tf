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

    Isso garante consistência:
    - todos os recursos que dependem de AZ usam as mesmas chaves
    - evita divergências entre stacks
  */

  for_each = local.az_map

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value

  /*
    CIDR das subnets:

    cidrsubnet(base, newbits, netnum)

    base    = var.vpc_cidr  (ex: 10.0.0.0/16)
    newbits = 4             (/16 -> /20)
    netnum  = índice do bloco

    Públicas:
      az1 -> 10.0.0.0/20
      az2 -> 10.0.16.0/20
  */

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    each.key == "az1" ? 0 : 1
  )

  /*
    Instâncias lançadas aqui podem receber IP público automaticamente.
  */

  map_public_ip_on_launch = true

  /*
    Tags importantes:

    kubernetes.io/role/elb
      → permite que LoadBalancers públicos sejam criados nessas subnets

    kubernetes.io/cluster/CLUSTER_NAME
      → indica que a subnet pode ser usada por este cluster
  */

  tags = merge(local.common_tags, {

  Name = "${local.name_prefix}-private-${each.key}"
  Tier = "private"
  AZ   = each.value

  "kubernetes.io/role/internal-elb" = "1"

  # TAG NECESSÁRIA PARA O EKS
  "kubernetes.io/cluster/${var.project_name}-${var.environment}-cluster" = "shared"

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
    Privadas usam blocos diferentes para evitar colisão.
  */

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    each.key == "az1" ? 10 : 11
  )

  /*
    NÃO recebem IP público automaticamente.
    A saída para internet será via NAT Gateway.
  */

  map_public_ip_on_launch = false

  /*
    Tags importantes para Kubernetes/EKS:

    kubernetes.io/role/internal-elb
      → permite que LoadBalancers internos usem essas subnets
  */

  tags = merge(local.common_tags, {

    Name = "${local.name_prefix}-private-${each.key}"
    Tier = "private"
    AZ   = each.value

    "kubernetes.io/role/internal-elb" = "1"

  })
}