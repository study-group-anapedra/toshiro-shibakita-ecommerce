/*
  provider.tf (stack 04-compute-eks)
  FUNÇÃO: Configurar o provedor AWS.
*/

provider "aws" {
  region  = var.aws_region
  profile = "terraform-dev" # O perfil que estamos usando no terminal

  default_tags {
    tags = var.tags
  }
}