# 🛒 **Toshiro-Shibakita – Plataforma de E-Commerce**
### *Infraestrutura em AWS • Microsserviços • Java/Spring • DevOps • TDD • Segurança • Alta Disponibilidade*

---
<p align="center">
  <img src="./artifacts/micro-infra-global-aws-architecture.png" 
       alt="Micro Infra Global Architecture" 
       width="100%">
</p>


---


## 📘 Visão Geral

O **Toshiro-Shibakita** é uma plataforma de e-commerce construída para simular um cenário corporativo real, com **arquitetura distribuída**, **infraestrutura automatizada** e **entrega contínua** na AWS.

O objetivo do projeto é demonstrar uma solução profissional completa, com **microsserviços**, **CI/CD**, **Infraestrutura como Código (Terraform)**, **padrões de engenharia** e uma organização **multirepo**, onde cada domínio tem vida própria.

---

# 🏛️ Arquitetura do Sistema

- Microsserviços (Spring Boot / Java 21) + serviços poliglotas (Go quando aplicável)
- Banco relacional: **PostgreSQL (Amazon RDS)**
- Cache: **Redis (Amazon ElastiCache)**
- Mensageria / Eventos: **Amazon SQS / SNS / EventBridge**
- Infraestrutura como Código: **Terraform**
- Containers: **Amazon EKS** (orquestração) + **ECR** (imagens)
- Segurança: IAM, JWT, Security Groups, NACLs, KMS
- Observabilidade: CloudWatch + X-Ray + OpenTelemetry

---

# 🧩 Domínios e Repositórios (Multirepo)

Este repositório é o **centro de governança da infraestrutura (IaC)**.  
Cada domínio de negócio roda em seu **próprio repositório**, com pipeline e deploy independentes.

> Substitua os links abaixo pelos URLs reais quando publicar os repositórios.

| Domínio / Serviço | Responsabilidade | Tecnologia | Repositório |
|---|---|---|---|
| **micro-infra-global** | Rede, segurança, dados, EKS, borda e DNS | Terraform | **(este repositório)** |
| **catalog-service** | Vitrine, produtos, categorias, mídia | Java 21 / Spring | `[link]()` |
| **inventory-service** | Estoque (source of truth), reservas/baixa | Go | `[link]()` |
| **order-service** | Pedidos, itens, status e integração por eventos | Java 21 / Spring | `[link]()` |
| **auth-service** | Autenticação, autorização, RBAC/JWT | Java / Spring Security | `[link]()` |
| **api-gateway** *(opcional)* | Entrada única, roteamento e políticas | Java / Gateway | `[link]()` |
| **notification-service** *(opcional)* | Processamento assíncrono e avisos | Go | `[link]()` |

---

### Endpoints (exemplo)

---

# 🔐 Segurança

- Autenticação JWT
- Spring Security
- IAM para serviços e pipelines (privilégio mínimo)
- SGs e NACLs seguindo princípio de menor privilégio
- Dados criptografados em trânsito (TLS) e repouso (KMS/RDS)

---

### Fluxo completo

---

# 🏗️ Infraestrutura — Terraform (Stacks Isoladas)

A infraestrutura é organizada em **stacks independentes** para reduzir *blast radius* e permitir evolução granular.


Sincronização via SQS/SNS/EventBridge (event-driven).

---


# 🛡️ Configurações de Segurança e Qualidade no GitHub



### Estrutura da Infra

```text

micro-infra-global/
│
├── stacks/                                  # stacks root (cada passo = 1 state isolado)
│   │
│   ├── 00-bootstrap/
│   │   ├── versions.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── main.tf                           # cria S3 tfstate + DynamoDB lock
│   │
    01-networking/
    │
    ├── versions.tf
    ├── backend.tf
      ├── provider.tf
      ├── locals.tf
      ├── variables.tf
      ├── vpc.tf
      ├── subnets.tf
      ├── igw.tf
      ├── eip.tf
      ├── nat.tf
      ├── route_tables.tf
      ├── routes.tf
      ├── associations.tf
      ├── outputs.tf
      └── data.tf

│   │
│   ├── 02-security/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── data.tf                           # remote_state: 01-networking
│   │   ├── outputs.tf
│   │   └── main.tf                           # chama o módulo security (SG + KMS base)
│   │
│   ├── 03-data/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf                      # “quais domínios usam o quê”
│   │   ├── data.tf                           # remote_state: 01-networking + 02-security
│   │   ├── outputs.tf
│   │   ├── main.tf                           # chama módulos rds/dynamodb/elasticache
│   │   │
│   │   ├── rds/                              # opcional: “camada” por serviço
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── main.tf
│   │   │
│   │   ├── dynamodb/
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── main.tf
│   │   │
│   │   └── elasticache/
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── main.tf
│   │
│   ├── 04-compute-eks/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── data.tf                           # remote_state: 01 + 02 + 03
│   │   ├── outputs.tf
│   │   └── main.tf                           # chama módulos eks + iam_eks + ecr + irsa
│   │
│   ├── 05-edge-delivery/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── data.tf                           # remote_state: 01 + 02 + 04
│   │   ├── outputs.tf
│   │   └── main.tf                           # chama módulos alb/acm/waf/cf/s3_frontend
│   │
│   ├── 06-dns-global/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── data.tf                        # remote_state: 05-edge-delivery
│   │   ├── outputs.tf
│   │   └── main.tf                           # chama módulo dns + validações acm
│   │
│   ├── 07-observability/
│   │   ├── versions.tf
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── data.tf                           # remote_state: 04 + 05
│   │   ├── outputs.tf
│   │   └── main.tf                           # chama módulo observability
│   │
│   └── 08-governance/
│       ├── versions.tf
│       ├── backend.tf
│       ├── provider.tf
│       ├── locals.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── main.tf                           # chama módulo governance (budgets/config/guardrails)
│
├── modules/                                 # módulos reutilizáveis (sem backend)
│   ├── networking/                          # vpc, subnets, nat, routes
│   ├── security/                            # sg + kms base
│   ├── data-rds/                            # rds + subnet group + parameter/option groups
│   ├── data-dynamodb/                       # dynamodb
│   ├── data-elasticache/                    # elasticache + subnet group
│   ├── compute-eks/                         # cluster + addons
│   ├── iam-eks/                             # iam técnico (cluster/nodes) + irsa/oidc
│   ├── ecr/                                 # repos por domínio
│   ├── edge-alb/                            # alb + listeners
│   ├── edge-acm/                            # certificados
│   ├── edge-waf/                            # waf (opcional)
│   ├── edge-cloudfront/                     # cloudfront (opcional)
│   ├── edge-s3-frontend/                    # bucket site/assets
│   ├── dns/                                 # route53 + validações
│   ├── observability/                       # cloudwatch + sns + dashboards
│   └── governance/                          # budgets + config + guardduty + guardrails
│
├── env/                                     # inputs por ambiente E por stack (padrão enterprise)
│   ├── dev/
│   │   ├── 00-bootstrap.tfvars
│   │   ├── 01-networking.tfvars
│   │   ├── 02-security.tfvars
│   │   ├── 03-data.tfvars
│   │   ├── 04-compute-eks.tfvars
│   │   ├── 05-edge-delivery.tfvars
│   │   ├── 06-dns-global.tfvars
│   │   ├── 07-observability.tfvars
│   │   └── 08-governance.tfvars
│   │
│   └── prod/
│       ├── 00-bootstrap.tfvars
│       ├── 01-networking.tfvars
│       ├── 02-security.tfvars
│       ├── 03-data.tfvars
│       ├── 04-compute-eks.tfvars
│       ├── 05-edge-delivery.tfvars
│       ├── 06-dns-global.tfvars
│       ├── 07-observability.tfvars
│       └── 08-governance.tfvars
│
├
└── env/
      ├── dev.tfvars 
      └── prod.tfvars






# 📜 Licença
MIT

---
# 💼 Sobre o Projeto

Este repositório foi criado para consolidar e demonstrar o aprendizado aplicado em:

- Arquitetura distribuída com microsserviços (Java e Go)
- DevOps moderno (CI/CD + Infraestrutura como Código)
- Provisionamento de infraestrutura na AWS com Terraform
- Boas práticas de backend, testes e qualidade de software
- Segurança, governança e organização multirepo

Aqui é onde a **infraestrutura é provisionada e organizada**, enquanto os domínios de negócio vivem em seus próprios repositórios.



