/*
  versions.tf

  Este arquivo define as “regras de compatibilidade” do Terraform para o projeto.

  Ele serve para garantir previsibilidade e evitar erros do tipo:
  - “na minha máquina funciona”
  - pipeline quebrando porque alguém usou uma versão diferente do Terraform/provider

  Aqui você fixa duas coisas:

  1) Terraform CLI (required_version)
     - Define qual versão mínima do Terraform pode executar este código.
     - Ex: ">= 1.6.0" significa: só roda com Terraform 1.6.0 ou mais novo.

  2) Providers (required_providers)
     - Provider é o “plugin” que permite o Terraform conversar com uma nuvem/serviço.
     - Aqui estamos usando o provider AWS oficial: hashicorp/aws
     - E fixamos uma faixa de versão do provider para evitar mudanças inesperadas.

  Boas práticas aplicadas aqui:
  ✔ Fixar versão mínima do Terraform (evita divergência local vs CI/CD)
  ✔ Fixar provider por source (segurança: garante origem do plugin)
  ✔ Fixar faixa de versão do provider (estabilidade do plano/apply)
*/

terraform {
  # Versão mínima do Terraform CLI aceita para este projeto
  required_version = ">= 1.6.0"

  # Providers exigidos pelo código
  required_providers {
    aws = {
      # Origem oficial do provider AWS
      source = "hashicorp/aws"

      # Faixa de versão do provider
      # "~> 5.0" = permite upgrades compatíveis dentro da major 5 (ex: 5.1, 5.20...)
      # mas bloqueia mudança para 6.x (que pode ter breaking changes).
      version = "~> 5.0"
    }
  }
}

