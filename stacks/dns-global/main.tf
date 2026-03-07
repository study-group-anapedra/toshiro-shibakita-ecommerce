/*
  main.tf (stack 07-dns-global)

  OBJETIVO:
  Consumir a Hosted Zone pública já existente e preparar a camada de DNS
  para apontar subdomínios da aplicação para a borda pública da arquitetura.

  PAPEL NA ARQUITETURA:
  - Localiza a zona pública do domínio raiz
  - Mantém referência ao certificado ACM já existente
  - Publica registros DNS da API
  - Evita recriação de certificado e nova validação DNS

  RELAÇÃO COM OUTRAS STACKS:
  - Conversa com a stack 06-edge-delivery ou com o runtime do Kubernetes
    quando houver um endpoint público para receber tráfego
  - Usa o domínio gerenciado no Route 53 como ponto central de entrada

  RECURSOS AWS ENVOLVIDOS:
  - data.aws_route53_zone
  - data.aws_acm_certificate
  - aws_route53_record

  RELEVÂNCIA:
  - Faz a ligação entre domínio público e aplicação
  - Permite reaproveitar certificado já emitido
  - Reduz custo operacional e tempo de espera em laboratório

  OBSERVAÇÃO:
  - Nesta versão, o registro da API está preparado como CNAME temporário
    para um endpoint externo configurável futuramente.
  - Quando houver ALB criado pelo Ingress Controller, o ideal é evoluir
    este arquivo para criar um registro A/ALIAS apontando para o load balancer.
*/

##################################################
# HOSTED ZONE EXISTENTE
##################################################

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

##################################################
# CERTIFICADO ACM EXISTENTE
##################################################

data "aws_acm_certificate" "main" {
  arn      = var.acm_certificate_arn
  statuses = ["ISSUED"]
}

##################################################
# REGISTRO DNS DA API
##################################################
# Este registro representa o subdomínio público principal da API.
# O valor abaixo funciona como placeholder controlado até que a
# arquitetura publique um endpoint definitivo do ALB/Ingress.
#
# Quando o ALB estiver consolidado, a recomendação é trocar este
# recurso para um registro A/ALIAS apontando diretamente para ele.

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_domain_name
  type    = "CNAME"
  ttl     = 300

  records = [var.domain_name]
}