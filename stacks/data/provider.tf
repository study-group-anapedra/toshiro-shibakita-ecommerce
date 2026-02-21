/*
  provider.tf (stack data)

  O que este arquivo faz?
  - Configura qual provider será usado (AWS).
  - Define a região onde os recursos serão criados.
  - Aplica tags padrão automaticamente em TODOS os recursos.

  Benefício:
  ✔ Governança (custos e auditoria).
  ✔ Multiambiente (dev/prod).
  ✔ Nenhum recurso nasce sem identificação.
*/

provider "aws" {

  # Região vem do tfvars (dev ou prod)
  region = var.aws_region

  /*
    default_tags:

    Tudo que for criado nesta stack
    receberá automaticamente estas tags.

    Evita esquecer tags em RDS, Redis ou DynamoDB.
  */
  default_tags {

    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
        Stack       = "data"
      },
      var.tags
    )
  }
}
