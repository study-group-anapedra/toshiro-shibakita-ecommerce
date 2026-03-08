/*
  provider.tf (stack 09-governance)

  IMPORTANTE
  No GitHub Actions com OIDC, não devemos usar profile local.
  A autenticação vem da action configure-aws-credentials.

  Portanto:
  - mantemos apenas a região
  - removemos qualquer profile local
*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}