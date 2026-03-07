/*
  main.tf (stack 04-compute-eks)

  FUNÇÃO:
  - Criar repositórios ECR (um para cada microsserviço)
  - Criar cluster EKS
  - Criar managed node group
  - Liberar a role do GitHub Actions para administrar o cluster EKS

  IMPORTANTE:
  - Aplicação será deployada depois
  - Aqui criamos apenas infraestrutura
  - Esta correção resolve o erro da stack 05-k8s-addons:
    Unauthorized ao criar namespace/service account via provider kubernetes

  POR QUE RESOLVE?
  - O cluster estava sendo criado corretamente
  - Mas a role usada pelo GitHub Actions não tinha permissão dentro do EKS
  - Então a stack 05 conseguia falar com a AWS, mas não com a API do Kubernetes
  - Com access_entries, a role do GitHub passa a ter acesso admin no cluster
*/

##############################
# 1. ECR - Repositórios
##############################

resource "aws_ecr_repository" "apps" {
  for_each = toset(local.services)

  name                 = "${var.environment}-${var.project_name}/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

##############################
# 2. EKS Cluster
##############################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  #################################
  # Nome do cluster
  #################################
  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  #################################
  # Acesso do GitHub Actions ao cluster
  #################################
  /*
    Esta é a correção principal.

    A stack 05-k8s-addons usa a role do GitHub Actions:
    arn:aws:iam::365646127398:role/gha-terraform-prod-toshiro-ecommerce

    Sem este bloco, o GitHub consegue criar recursos AWS,
    mas não consegue acessar a API do Kubernetes no EKS.

    Resultado do erro sem isso:
    - kubernetes_namespace => Unauthorized
    - kubernetes_service_account => Unauthorized

    Com este bloco:
    - a role entra como principal do cluster
    - recebe política de admin no escopo do cluster inteiro
    - a stack 05 passa a conseguir instalar o AWS Load Balancer Controller
  */
  access_entries = {
    github_actions = {
      principal_arn = "arn:aws:iam::365646127398:role/gha-terraform-prod-toshiro-ecommerce"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  #################################
  # Correção do erro 38 chars
  #################################
  iam_role_use_name_prefix            = false
  cluster_security_group_use_name_prefix = false
  node_security_group_use_name_prefix    = false

  #################################
  # Endpoint público (estudo)
  #################################
  cluster_endpoint_public_access = true

  #################################
  # Networking
  #################################
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  #################################
  # Node Group (Dev Econômico)
  #################################
  eks_managed_node_groups = {
    dev_nodes = {
      iam_role_use_name_prefix = false

      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      tags = {
        Name = "${var.environment}-dev-nodes"
      }
    }
  }

  #################################
  # Tags Globais
  #################################
  tags = var.tags
}