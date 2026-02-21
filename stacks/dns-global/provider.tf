/*
  provider.tf (stack 06-dns-global)
*/

provider "aws" {
  region  = var.aws_region
  profile = "terraform-dev"

  default_tags {
    tags = var.tags
  }
}