/*
  stacks/k8s-addons/data.tf

  FUNÇÃO:
  Lê outputs das stacks anteriores (especificamente da 04-compute-eks).

  Terraform NÃO compartilha dados sozinho.
  Remote state é obrigatório para que esta stack saiba o nome e o endpoint do cluster.

  COMUNICA COM:
  ✔ compute-eks (prod/compute-eks/terraform.tfstate)
*/

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    
    # CORREÇÃO: Adicionado o prefixo "prod/" para alinhar com o caminho 
    # definido no seu arquivo terraform-stacks.yml
    key    = "prod/compute-eks/terraform.tfstate"
    
    region = var.aws_region
  }
}