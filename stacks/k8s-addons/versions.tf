/*
  versions.tf

  FUNÇÃO:
  Garante versões consistentes do Terraform e Providers.

  RELEVÂNCIA:
  Evita comportamento diferente em máquinas distintas.
*/

terraform {

  required_version = ">= 1.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }

  }

}