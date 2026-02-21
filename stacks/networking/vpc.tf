/*
  vpc.tf

  Este arquivo cria a VPC base da arquitetura.

  A VPC é o “container” de rede onde todos os recursos irão existir:
  - Subnets públicas e privadas
  - ALB / NAT Gateway
  - Compute (EC2/ECS/EKS)
  - Bancos (RDS)
  - Security Groups, endpoints, etc.

  Boas práticas aplicadas aqui:
  ✔ CIDR /16 (ou outro) vindo de variável (sem hardcode)
  ✔ DNS Support + DNS Hostnames habilitados (necessário para ALB/RDS/Service Discovery)
  ✔ Tags padronizadas via locals (governança + custo + auditoria)
*/

resource "aws_vpc" "main" {
  # Bloco CIDR principal da VPC (ex: 10.0.0.0/16)
  cidr_block = var.vpc_cidr

  # Necessário para resolução DNS dentro da VPC (ex.: RDS endpoint, service discovery)
  enable_dns_support = true

  # Necessário para que instâncias recebam nomes DNS internos
  enable_dns_hostnames = true

  # Tags do recurso (padronizadas) + Name humano-legível
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

