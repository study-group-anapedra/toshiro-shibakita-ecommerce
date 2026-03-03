/*
  provider.tf (stack 05-k8s-addons)

  FUNÇÃO:
  - Configurar providers:
    ✔ aws (para IRSA/IAM/policies)
    ✔ kubernetes (para criar service accounts, namespaces, etc.)

  POR QUE DAVA "Unauthorized":
  - O provider kubernetes não estava autenticando no cluster.
  - Em GitHub Actions (OIDC), o jeito correto é:
    - buscar endpoint/CA do remote_state (stack 04)
    - gerar token temporário via data.aws_eks_cluster_auth

  IMPORTANTE:
  - NÃO usa profile.
  - Funciona local e no GitHub Actions.
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

# Busca metadados do cluster (endpoint/ca) pelo nome
data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

# Gera token autenticado (equivalente ao `aws eks get-token`)
data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

# Provider Kubernetes autenticando no EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}