/*
  versions.tf

  Este arquivo define:
  1) A versão mínima do Terraform que pode executar este projeto.
  2) Qual provider será usado (AWS).
  3) A versão do provider para garantir estabilidade e evitar que atualizações
     automáticas quebrem a infraestrutura.

  Ele garante previsibilidade, padronização e compatibilidade do ambiente.
  Em ambientes profissionais isso evita problemas entre times e pipelines CI/CD.
*/

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
