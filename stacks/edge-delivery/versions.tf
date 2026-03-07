/*
  versions.tf (stack 06-edge-delivery)

  OBJETIVO:
  Fixar a versão mínima do Terraform e dos providers usados nesta stack.

  CORREÇÃO APLICADA:
  - Removido provider kubernetes, pois esta stack não cria recursos Kubernetes
  - Mantido apenas provider AWS, que é o único necessário aqui
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}