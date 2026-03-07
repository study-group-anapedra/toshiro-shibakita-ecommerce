/*
  data.tf (stack 05-k8s-addons)

  OBJETIVO
  Permitir que esta stack leia informações das stacks anteriores
  já aplicadas via Terraform Remote State.

  STACKS UTILIZADAS
  - 04-compute-eks → fornece dados do cluster Kubernetes
  - 01-networking  → fornece dados da VPC

  POR QUE ISSO É NECESSÁRIO

  Os arquivos main.tf e provider.tf usam valores como:

  data.terraform_remote_state.eks.outputs.cluster_name
  data.terraform_remote_state.eks.outputs.cluster_endpoint
  data.terraform_remote_state.eks.outputs.cluster_ca_certificate
  data.terraform_remote_state.eks.outputs.oidc_provider_arn
  data.terraform_remote_state.eks.outputs.oidc_provider_url

  e

  data.terraform_remote_state.networking.outputs.vpc_id

  Sem este arquivo Terraform não sabe de onde buscar esses outputs
  e gera o erro:

  Reference to undeclared resource
  data.terraform_remote_state.eks
*/

############################################################
# Remote State da stack 04 - compute-eks
############################################################

data "terraform_remote_state" "eks" {

  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/compute-eks/terraform.tfstate"
    region = var.aws_region
  }
}

############################################################
# Remote State da stack 01 - networking
############################################################

data "terraform_remote_state" "networking" {

  backend = "s3"

  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/networking/terraform.tfstate"
    region = var.aws_region
  }
}