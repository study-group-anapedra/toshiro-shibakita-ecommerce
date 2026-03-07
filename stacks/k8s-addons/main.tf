/*
  main.tf (stack 05-k8s-addons)

  OBJETIVO
  Esta stack instala componentes dentro do cluster Kubernetes
  criado na stack 04-compute-eks.

  COMPONENTES INSTALADOS
  - AWS Load Balancer Controller (via Helm)
  - ServiceAccount com IRSA

  CORREÇÃO APLICADA
  - Removido o resource do namespace kube-system, porque esse namespace
    já existe por padrão no EKS.
  - Isso resolve o erro:
      namespaces "kube-system" already exists

  COMO FUNCIONA
  1. Lê dados do cluster via remote_state (stack 04)
  2. Cria IAM Policy necessária
  3. Cria IAM Role para IRSA
  4. Cria ServiceAccount no namespace kube-system
  5. Instala o Helm chart do AWS Load Balancer Controller
*/

############################################################
# IAM Policy para o AWS Load Balancer Controller
############################################################

resource "aws_iam_policy" "alb_controller" {
  name        = "${var.project_name}-${var.environment}-alb-controller"
  description = "Policy for AWS Load Balancer Controller"

  policy = file("${path.module}/alb-iam-policy.json")
}

############################################################
# IAM Role para IRSA
############################################################

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.terraform_remote_state.eks.outputs.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.eks.outputs.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "${var.project_name}-${var.environment}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

############################################################
# Service Account (IRSA)
############################################################

resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}

############################################################
# Instala AWS Load Balancer Controller via Helm
############################################################

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller.metadata[0].name
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.networking.outputs.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller,
    kubernetes_service_account.alb_controller
  ]
}