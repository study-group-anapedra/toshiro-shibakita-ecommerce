/*
  locals.tf (stack 02-security)

  Objetivo:
  ----------
  Centralizar padrões internos da stack security.

  Aqui NÃO criamos recursos.
  Apenas organizamos:

  - Prefixo padrão de nomes
  - Tags comuns
  - Portas padrão por engine (para uso futuro)
*/

############################
# Prefixo padrão
############################

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

############################
# Tags padrão
############################

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Stack       = "security"
  }
}

############################
# Portas por engine (uso futuro)
############################

locals {
  ports = {
    postgres = 5432
    mysql    = 3306
    redis    = 6379
  }
}
