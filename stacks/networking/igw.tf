/*
  igw.tf

  Este arquivo cria o Internet Gateway (IGW).

  O IGW é o componente que conecta a VPC à internet.

  Regras importantes:
  - Existe no máximo 1 IGW anexado por VPC (padrão comum).
  - Ele é usado pelas subnets públicas através da Route Table pública
    (rota 0.0.0.0/0 -> IGW).

  Para que ele serve na prática:
  - Permitir tráfego de entrada/saída em recursos públicos (ex.: ALB público).
  - Permitir que o NAT Gateway (que fica em subnet pública) tenha saída para a internet.
  - Subnets privadas NÃO apontam diretamente para o IGW (elas saem via NAT).
*/

resource "aws_internet_gateway" "main" {
  # Anexa o IGW na VPC criada no vpc.tf
  vpc_id = aws_vpc.main.id

  # Tags padronizadas + Name humano-legível
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

