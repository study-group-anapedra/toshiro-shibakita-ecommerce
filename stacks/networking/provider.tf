/*
  provider.tf

  Este arquivo configura o provider AWS,
  ou seja, é ele que permite que o Terraform
  se conecte à sua conta da AWS para criar recursos.

  Aqui definimos:

  - region → Em qual região os recursos serão criados.
  - default_tags → Tags automáticas aplicadas em TODOS os recursos.

  O uso de default_tags é prática profissional,
  pois garante padronização, governança e organização
  para controle de custos e auditoria.

  Isso evita esquecer tags importantes em recursos individuais.
*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
