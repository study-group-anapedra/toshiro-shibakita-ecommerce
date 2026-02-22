/*
  data.tf

  Importa o remote state da stack networking.
  Permite que a stack security utilize outputs como vpc_id
  sem recriar recursos de rede.

  Observacao importante:
  - O key deve ser IDENTICO ao caminho existente no S3.
  - Neste projeto o state esta em:
    01-networking/terraform.tfstate
*/

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "toshiro-ecommerce-prod-tfstate"
    key    = "01-networking/terraform.tfstate"
    region = "us-east-1"
  }
}
