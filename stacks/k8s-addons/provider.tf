/*
  stacks/k8s-addons/provider.tf

  OBJETIVO:
  Configurar os providers necessários para esta stack:

  - AWS: cria IAM Policy/Role (IRSA)
  - Kubernetes: cria ServiceAccount com anotação IRSA
  - Helm: instala o AWS Load Balancer Controller

  COM O QUE SE COMUNICA:
  - terraform_remote_state "eks" (cluster_name, endpoint, ca cert)
  - AWS EKS Auth (token temporário para acessar o cluster)

  ERRO QUE VOCÊ ESTAVA VENDO:
  Ele acontece quando o bloco kubernetes provider está incompleto
  (ex.: base64decode solto sem estar atribuído a cluster_ca_certificate).
  Este arquivo abaixo está completo e correto.
*/

provider "aws" {
  region = var.aws_region
}

# Token temporário para autenticar no API Server do EKS
data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host = data.terraform_remote_state.eks.outputs.cluster_endpoint

  # O output do EKS vem em base64 -> precisamos decodificar para TLS funcionar
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.eks.outputs.cluster_ca_certificate
  )

  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host = data.terraform_remote_state.eks.outputs.cluster_endpoint

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.eks.outputs.cluster_ca_certificate
    )

    token = data.aws_eks_cluster_auth.this.token
  }
}