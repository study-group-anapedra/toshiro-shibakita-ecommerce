/*
  main.tf (stack 04-compute-eks)

  FUNÇÃO:
  - Criar repositórios ECR (um para cada microsserviço)
  - Criar cluster EKS
  - Criar managed node group

  IMPORTANTE:
  - Aplicação será deployada depois (outro repositório pode fazer CI/CD separado)
  - Aqui criamos apenas infraestrutura
  - Corrigido problema de limite 38 caracteres do name_prefix
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
  # 🔥 CORREÇÃO DO ERRO 38 CHARS
  #################################
  iam_role_use_name_prefix = false
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