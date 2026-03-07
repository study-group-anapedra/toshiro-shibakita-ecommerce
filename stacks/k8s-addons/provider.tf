/*
  provider.tf (stack 05-k8s-addons)

  OBJETIVO:
  Configurar os providers necessários para esta stack:
  - AWS: cria IAM/IRSA/policies
  - Kubernetes: cria recursos dentro do cluster
  - Helm: instala charts no cluster (ex.: AWS Load Balancer Controller)

  COMO FUNCIONA:
  - O cluster já foi criado na stack 04-compute-eks
  - Esta stack lê os dados do cluster via remote_state
  - Depois gera um token temporário com aws_eks_cluster_auth
  - Com isso, Terraform consegue autenticar no Kubernetes sem usar profile fixo

  IMPORTANTE:
  - Não duplicar provider "aws"
  - Não duplicar data "aws_eks_cluster_auth" "this"
  - Não duplicar provider "kubernetes"
*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
        Stack       = "05-k8s-addons"
      },
      var.tags
    )
  }
}

# Gera token temporário autenticado no cluster EKS
data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

# Provider Kubernetes autenticando no cluster criado na stack 04
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Provider Helm usando a mesma autenticação do Kubernetes
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}