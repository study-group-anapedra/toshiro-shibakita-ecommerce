/*
  stacks/data/data.tf

  Função deste arquivo
  --------------------
  Este arquivo “liga” a stack 03-data às stacks anteriores (networking e security)
  sem você copiar/colar IDs (VPC, subnets, security groups).

  Como ele faz isso
  -----------------
  Ele lê os OUTPUTS publicados no state remoto (S3) das stacks anteriores.
  Ou seja: networking/security exportam outputs -> aqui a stack data consome.

  Ponto mais importante (o seu erro anterior)
  -------------------------------------------
  Você estava apontando para o bucket DEV hardcoded:
    bucket = "toshiro-ecommerce-dev-tfstate"
  Em PROD isso quebra (ou pega IDs errados).

  Por isso aqui:
  - bucket vem de var.remote_backend_bucket_name (definida no prod.tfvars)
  - keys vêm de variáveis (ajustáveis para bater com o "key" do backend.tf das stacks)
*/

# ---------------------------------------------------------
# State remoto da stack networking (VPC + Subnets)
# ---------------------------------------------------------
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    # Bucket do state remoto do ambiente (ex: toshiro-ecommerce-prod-tfstate)
    bucket = var.remote_backend_bucket_name

    /*
      IMPORTANTE:
      O valor abaixo PRECISA bater com o "key" configurado no backend.tf
      da stack networking.

      Se o seu backend.tf da stack networking usa algo como:
        key = "networking/terraform.tfstate"
      então deixe exatamente assim.

      Se você tiver numerado (ex: "01-networking/terraform.tfstate"),
      ajuste a variável remote_state_key_networking em variables.tf/prod.tfvars.
    */
    key    = var.remote_state_key_networking
    region = var.aws_region
  }
}

# ---------------------------------------------------------
# State remoto da stack security (SGs)
# ---------------------------------------------------------
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name

    /*
      Mesma regra:
      PRECISA bater com o "key" do backend.tf da stack security.

      Exemplo comum:
        key = "security/terraform.tfstate"
    */
    key    = var.remote_state_key_security
    region = var.aws_region
  }
}

# ---------------------------------------------------------
# Consolida “valores finais” para a stack data usar
# ---------------------------------------------------------
locals {
  # IDs vindos do networking (outputs.tf da stack networking)
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  # IDs vindos da security (outputs.tf da stack security)
  # Ajuste estes nomes para bater 100% com o outputs.tf real da stack security.
  rds_sg_id   = data.terraform_remote_state.security.outputs.sg_rds_id
  redis_sg_id = data.terraform_remote_state.security.outputs.sg_redis_id
}