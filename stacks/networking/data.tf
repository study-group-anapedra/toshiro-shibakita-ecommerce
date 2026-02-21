/*
  data.tf

  Este arquivo consulta informações já existentes na AWS.
  Ele NÃO cria recursos.

  Aqui usamos um "data source" para buscar
  as Availability Zones (AZs) disponíveis na região.

  Isso é importante porque:

  - Permite criar subnets em múltiplas AZs
  - Garante alta disponibilidade
  - Evita hardcode de nomes como "us-east-1a"

  Em vez de fixar zonas manualmente,
  deixamos o Terraform descobrir automaticamente.
*/

# Busca as zonas de disponibilidade disponíveis
data "aws_availability_zones" "available" {
  state = "available"
}
