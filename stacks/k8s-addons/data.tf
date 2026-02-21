/*
  data.tf

  FUNÇÃO:
  Lê outputs das stacks anteriores.

  Terraform NÃO compartilha dados sozinho.
  Remote state é obrigatório.

  COMUNICA COM:

  ✔ compute-eks outputs.tf
  ✔ networking
*/

data "terraform_remote_state" "eks" {

  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "compute-eks/terraform.tfstate"
    region = var.aws_region
  }

}