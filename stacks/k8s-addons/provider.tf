/*
  stacks/k8s-addons/provider.tf

  OBJETIVO:
  Configurar os providers necessários para esta stack:
  - AWS: Cria IAM Policies e Roles para o IRSA (IAM Roles for Service Accounts).
  - Kubernetes: Cria ServiceAccounts dentro do cluster com anotações de segurança.
  - Helm: Instala o AWS Load Balancer Controller, essencial para gerenciar múltiplos domínios e microserviços.

  COM O QUE SE COMUNICA:
  - terraform_remote_state "eks": Obtém o endpoint e o certificado do cluster criado na Stack 04.
  - AWS EKS Auth: Gera o token temporário necessário para o Terraform "entrar" no cluster.

  RELEVÂNCIA:
  - Este arquivo garante que o Terraform tenha permissão para instalar componentes dentro do Kubernetes
    sem usar credenciais fixas, mantendo o padrão de segurança Enterprise.

    OBJETIVO: Configurar AWS, Kubernetes e Helm para instalar o Load Balancer Controller.
      OBJETIVO: Configurar AWS, Kubernetes e Helm para instalar o Load Balancer Controller.

*/



provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Stack       = "05-k8s-addons"
    }
  }
}

# Gera o token dinâmico para o Terraform entrar no cluster recém-criado
data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}