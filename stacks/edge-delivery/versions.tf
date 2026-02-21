/*
  versions.tf (stack 04-compute-eks)
  DIDÁTICA: Garante que todos usem a mesma versão do Terraform e dos plugins AWS/Kubernetes.
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}