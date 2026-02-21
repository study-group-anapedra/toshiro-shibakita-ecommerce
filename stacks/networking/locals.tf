/*
  locals.tf

  Este arquivo define valores internos reutilizáveis no stack.
  Locals NÃO recebem valores externos.
  Eles são processados apenas dentro deste módulo.

  Por que usar locals?

  ✔ Evita repetição de código
  ✔ Padroniza nomenclatura
  ✔ Centraliza lógica de composição
  ✔ Facilita manutenção futura
*/

locals {

  /*
    ---------------------------------------------------------
    PREFIXO PADRÃO DE NOMES
    ---------------------------------------------------------

    Cria um prefixo único para todos os recursos
    combinando project_name + environment.

    Exemplo:
      toshiro-ecommerce-dev
      toshiro-ecommerce-prod

    Isso evita colisão de nomes entre ambientes.
  */
  name_prefix = "${var.project_name}-${var.environment}"


  /*
    ---------------------------------------------------------
    TAGS PADRÃO DO STACK
    ---------------------------------------------------------

    Essas tags serão aplicadas manualmente
    em recursos que usam merge(local.common_tags, {...})

    Observação importante:
    Mesmo usando default_tags no provider,
    manter common_tags ajuda quando queremos
    complementar ou sobrescrever valores.

    Padrão enterprise:
      - Project
      - Environment
      - ManagedBy
  */
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }


  /*
    ---------------------------------------------------------
    ZONAS DE DISPONIBILIDADE (AZs)
    ---------------------------------------------------------

    data.aws_availability_zones.available.names
    retorna TODAS as AZs disponíveis na região.

    slice(..., 0, 2) pega apenas as duas primeiras.

    Por que fazer isso?

    ✔ Alta disponibilidade (Multi-AZ)
    ✔ Evita hardcode como "us-east-1a"
    ✔ Funciona em qualquer região
    ✔ Permite escalar para 3 AZs futuramente

    Resultado exemplo:
      ["us-east-1a", "us-east-1b"]
  */
  azs = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )


  /*
    ---------------------------------------------------------
    MAPA DE AZs PARA USAR COM for_each
    ---------------------------------------------------------

    Criamos um mapa estável para usar com for_each.

    Isso garante chaves previsíveis:
      az1
      az2

    Em vez de depender do nome físico da AZ,
    usamos identificadores lógicos.

    Resultado exemplo:
    {
      az1 = "us-east-1a"
      az2 = "us-east-1b"
    }

    Isso é mais profissional porque:
    ✔ Evita problemas se a AWS mudar ordem das AZs
    ✔ Mantém padrão consistente em todos os recursos
    ✔ Facilita expansão futura
  */
  az_map = {
    az1 = local.azs[0]
    az2 = local.azs[1]
  }

}

