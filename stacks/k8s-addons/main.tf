/*
  stacks/k8s-addons/main.tf

  OBJETIVO:
  Instalar o AWS Load Balancer Controller com IRSA (OIDC),
  para que o Kubernetes crie/gerencie o ALB automaticamente via Ingress.

  COM O QUE ESTE ARQUIVO SE COMUNICA:
  - terraform_remote_state "eks" (lê cluster_name e OIDC do compute-eks)
  - aws provider (cria policy/role/attachment)
  - helm provider (instala o chart no cluster)

  POR QUE É RELEVANTE:
  Sem IRSA + controller, o Ingress não consegue criar ALB na AWS.
*/

###############################
# 1) IAM POLICY (permissões do controller)
###############################

resource "aws_iam_policy" "alb_controller" {
  name        = "${var.project_name}-${var.environment}-alb-controller"
  description = "Permissões para o AWS Load Balancer Controller (EKS Ingress -> ALB)."

  # JSON externo (alb-iam-policy.json) mantido em arquivo para ficar auditável.
  policy = file("${path.module}/alb-iam-policy.json")
}

###############################
# 2) IRSA (IAM Role for Service Account)
###############################
# IRSA exige:
# - OIDC habilitado no EKS (compute-eks outputs)
# - Trust policy apontando para o issuer OIDC e para o ServiceAccount correto

locals {
  alb_namespace       = "kube-system"
  alb_service_account = "aws-load-balancer-controller"
  oidc_provider_arn   = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  oidc_provider_url   = data.terraform_remote_state.eks.outputs.oidc_provider_url
  oidc_provider_host  = replace(local.oidc_provider_url, "https://", "")
}

data "aws_iam_policy_document" "alb_assume_role" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    # Restringe a role para APENAS este ServiceAccount (segurança real)
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_host}:sub"
      values   = ["system:serviceaccount:${local.alb_namespace}:${local.alb_service_account}"]
    }

    # Garante que o audience é o padrão do STS
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_host}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "alb_irsa" {
  name               = "${var.project_name}-${var.environment}-alb-irsa"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_irsa.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

###############################
# 3) KUBERNETES SERVICE ACCOUNT (anotado com a role IRSA)
###############################
# O Helm chart pode criar o ServiceAccount, mas aqui nós controlamos
# explicitamente para garantir a anotação IRSA correta.

resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = local.alb_service_account
    namespace = local.alb_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_irsa.arn
    }

    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
}

###############################
# 4) HELM INSTALL (instala o controller no cluster)
###############################

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = local.alb_namespace

  # Garante que o ServiceAccount criado acima exista antes do Helm instalar
  depends_on = [kubernetes_service_account.alb_controller]

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_name
  }

  # Diz ao chart para NÃO criar ServiceAccount (porque nós já criamos com IRSA)
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = local.alb_service_account
  }
}