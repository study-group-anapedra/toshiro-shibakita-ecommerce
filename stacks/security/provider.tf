/*
  provider.tf

  Este arquivo configura o provider AWS,
  ou seja, permite que o Terraform se conecte à sua conta AWS.

  Aqui NÃO usamos valores hardcoded.
  Tudo vem de variáveis, mantendo o padrão enterprise.

  O que definimos:

  - region → vem de var.aws_region
  - default_tags → padrão organizacional aplicado automaticamente

  Por que usar variáveis?

  ✔ Permite reutilizar a stack em dev/prod
  ✔ Evita código fixo e inflexível
  ✔ Mantém consistência entre stacks
  ✔ Facilita CI/CD multi-ambiente
*/

provider "aws" {

  # Região definida via variável (ex: dev.tfvars)
  region = var.aws_region

  # Tags automáticas aplicadas em todos os recursos
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Stack       = "security"
    }
  }
}
