/*
  main.tf (stack 04-compute-eks)
  FUNÇÃO: Criar o Cluster EKS e os repositórios ECR.
  POR QUE: É o "computador" onde seus containers Java e Go serão executados.
*/

# 1. Repositórios ECR (Um para cada serviço da lista no locals)
resource "aws_ecr_repository" "apps" {
  for_each             = toset(local.services)
  name                 = "${var.environment}-${var.project_name}/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

# 2. Cluster EKS Simplificado (Usando Managed Node Group para Dev)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  # Permite acesso público ao endpoint do cluster (apenas para facilitar seu estudo)
  cluster_endpoint_public_access = true

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  # Conecta com o Security Group de APPS que permite falar com RDS/Redis
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  eks_managed_node_groups = {
    dev_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"] # Econômico para rodar Spring Boot
      capacity_type  = "SPOT"        # Máxima economia de custos para Dev
    }
  }

  tags = var.tags
}