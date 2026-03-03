/*
  data.tf (stack 05-k8s-addons)

  FUNÇÃO:
  - Ler (via remote_state) os outputs do cluster EKS criado na stack 04-compute-eks.

  POR QUE:
  - O provider "kubernetes" precisa do:
    ✔ endpoint da API do cluster
    ✔ CA certificate
    ✔ nome do cluster (para gerar token via aws eks get-token)

  DEPENDE DE:
  - stack 04-compute-eks ter outputs:
    cluster_name, cluster_endpoint, cluster_ca_certificate, oidc_provider_arn, oidc_provider_url
*/

data "terraform_remote_state" "compute_eks" {
  backend = "s3"
  config = {
    bucket = var.remote_backend_bucket_name
    key    = "prod/compute-eks/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  cluster_name           = data.terraform_remote_state.compute_eks.outputs.cluster_name
  cluster_endpoint       = data.terraform_remote_state.compute_eks.outputs.cluster_endpoint
  cluster_ca_certificate = data.terraform_remote_state.compute_eks.outputs.cluster_ca_certificate

  oidc_provider_arn = data.terraform_remote_state.compute_eks.outputs.oidc_provider_arn
  oidc_provider_url = data.terraform_remote_state.compute_eks.outputs.oidc_provider_url
}