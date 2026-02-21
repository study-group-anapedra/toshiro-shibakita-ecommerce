/*
  versions.tf (stack 06-dns-global)
  DIDÁTICA: Trava as versões para garantir estabilidade no Route 53 e ACM.
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