/*
  provider.tf (stack 08-observability)

  IMPORTANTE
  No GitHub Actions com OIDC, NÃO devemos usar profile local.
  A autenticação vem automaticamente da action configure-aws-credentials.

  Por isso:
  - mantemos apenas a region
  - removemos qualquer profile local
*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}