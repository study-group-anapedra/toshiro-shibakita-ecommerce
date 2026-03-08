/*
  main.tf (stack 07-dns-global)

  OBJETIVO:
  Consumir a Hosted Zone pública já existente e preparar a camada de DNS
  para apontar subdomínios da aplicação para a borda pública da arquitetura.

  PAPEL NA ARQUITETURA:
  - Reutiliza a hosted zone pública já existente
  - Reutiliza um certificado ACM já emitido por meio de variável
  - Publica registros DNS necessários para entrada pública da aplicação
  - Mantém esta stack focada apenas na camada DNS

  RELAÇÃO COM OUTRAS STACKS:
  - Usa a hosted zone localizada em data.tf
  - Pode consumir outputs da stack edge-delivery quando houver endpoint público
  - Mantém integração com ACM apenas como referência ao certificado existente

  RECURSOS AWS ENVOLVIDOS:
  - aws_route53_record

  RELEVÂNCIA:
  - Centraliza a publicação de registros DNS
  - Evita recriação desnecessária de certificado
  - Deixa a responsabilidade de busca de dados separada da criação de recursos

  OBSERVAÇÃO:
  - O data "aws_route53_zone" "main" já existe em data.tf
  - Portanto ele não deve ser repetido aqui
  - O certificado ACM existente já é recebido por variável
  - Portanto não deve haver data "aws_acm_certificate" neste arquivo
  - O registro api.asantanadev.com já pode existir manualmente no Route53,
    por isso allow_overwrite = true evita conflito no apply
*/

##################################################
# REGISTRO DNS DA API
##################################################
# Este registro representa o subdomínio público principal da API.
# Neste momento ele está como CNAME temporário.
# Quando existir um endpoint público definitivo, este valor poderá ser
# evoluído para apontar para o destino correto da aplicação.

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_domain_name
  type    = "CNAME"
  ttl     = 300

  allow_overwrite = true

  records = [var.domain_name]
}