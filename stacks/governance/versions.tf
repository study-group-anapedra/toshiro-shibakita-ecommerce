/*
  versions.tf (stack 09-governance)

  Define:
  - versão mínima do Terraform
  - provider AWS utilizado pela stack
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