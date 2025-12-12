# 🛒 **Toshiro-Shibakita – Plataforma de E-Commerce**
### *Infraestrutura em AWS • Microsserviços • Java/Spring • DevOps • TDD • Segurança • Alta Disponibilidade*

---

## 📘 Visão Geral

O **Toshiro-Shibakita** é um sistema de e-commerce moderno desenvolvido para uma rede de supermercados da Região Metropolitana de São Paulo.

O objetivo do projeto é demonstrar uma solução profissional completa, com arquitetura escalável, microsserviços, CI/CD corporativo, infraestrutura automatizada e padrões de engenharia de software.

---

# 🏛️ Arquitetura do Sistema

- Microsserviços (Spring Boot / Java 21)  
- Banco: **PostgreSQL (RDS)**  
- Mensageria: SQS/SNS  
- Eventos de domínio  
- Infraestrutura como Código: **Terraform**  
- Containers ECS Fargate  
- Segurança corporativa: IAM, JWT, SGs, NACLs  
- Observabilidade completa (CloudWatch + X-Ray + OTel)

---

# 📦 Primeira Feature – *Catálogo de Produtos*

O primeiro microsserviço implementado é o **catalog-service**.

### Funcionalidades
- Listagem de produtos  
- Busca e filtros  
- Imagens (S3 + CloudFront)  
- Consulta de estoque (somente leitura)  
- Cache Redis (ElastiCache)

### Endpoints (exemplo)

```
GET /products
GET /products/{id}
GET /categories
```

---

# 🧱 Padrões e Boas Práticas

- Arquitetura Hexagonal  
- SOLID + Clean Code  
- DTOs → Controllers limpos  
- Services → Regras de negócio  
- Repositories → Acesso ao banco  
- Mapeamento com MapStruct  
- Versionamento SQL com Flyway  
- Exception Handler global

---

# 🔐 Segurança

- Autenticação JWT  
- Spring Security  
- IAM para serviços e pipelines  
- SGs e NACLs com princípio de menor privilégio  
- Dados criptografados em trânsito (TLS) e repouso (KMS/RDS)

---

# 🧪 Qualidade de Software (TDD)

### Testes implementados:
- Unitários (JUnit 5 + Mockito)  
- Integração (Testcontainers PostgreSQL)  
- Repositórios  
- Testes de contrato HTTP  
- Linters: Checkstyle, SpotBugs  
- SonarCloud no pipeline  
- Cobertura alvo: **80%+**

---

# 🚀 CI/CD — GitHub Actions

Pipeline moderno com gatilhos:

- **Pull Request → branch main/dev/stage**  
- Build e testes  
- Análise de qualidade  
- Build Docker  
- Deploy automático (via Terraform + ECS)  

### Fluxo completo

```
feature-branch → Pull Request → Code Review → CI → Merge → Deploy
```

---

# 🏗️ Infraestrutura — Terraform

Estrutura de IaC:

```
infra/
  modules/
    vpc/
    rds/
    s3/
    ecs/
    alb/
  environments/
    dev/
    staging/
    prod/
```

Provisiona:

- VPC Multi-AZ  
- Subnets públicas/privadas  
- ALB  
- ECS Fargate  
- RDS PostgreSQL  
- Security Groups  
- S3 + CloudFront  
- SQS/SNS/EventBridge  
- Logs + Observabilidade  

---

# 🔄 Integrações (ERP/PDV)

Eventos principais:

- `inventory.updated`  
- `price.changed`  
- `product.created`  
- `product.disabled`

Sincronização via SQS/SNS/EventBridge.

---

# 🔧 Como Rodar Localmente

### Requisitos
- Java 21  
- Maven  
- Docker  
- Docker Compose

### Comandos

```
docker compose up -d
mvn spring-boot:run
```

---

# 🧭 Roadmap

### MVP – Catálogo (FASE ATUAL)
- Microsserviço catálogo  
- Infra dev via Terraform  
- CI completo  
- Deploy Fargate  
- Observabilidade  

### Próximos módulos
- Carrinho  
- Checkout  
- Pagamentos  
- Entregas  
- Fidelidade  
- Aplicativo mobile  

---

# 🛡️ Configurações de Segurança e Qualidade no GitHub

Para garantir qualidade profissional, configure:

---

## 🔒 Proteção da branch `main`

No GitHub:

Repositorio → Settings → Branches → Branch Protection Rules

Configure:

- ✔ **Require pull request before merging**  
- ✔ **Require code review approvals (min 1 ou 2)**  
- ✔ **Require status checks to pass before merging**  
    - build  
    - testes  
    - sonarcloud  
    - lint  
- ✔ **Require signed commits (opcional, recomendado)**  
- ✔ **Require branches to be up to date**  
- ✔ **Do not allow bypass**  
- ✔ **Restrict who can push to main**  

---

## 🧑‍💻 Code Review (Best Practices)

Checklist para revisores:

- [ ] Código limpo, sem duplicação  
- [ ] Testes cobrindo nova lógica  
- [ ] Validações e exceções adequadas  
- [ ] Segurança (inputs, dados sensíveis)  
- [ ] Logs essenciais  
- [ ] Não incluir secrets no código  
- [ ] Terraform formatado e validado  
- [ ] Dockerfile otimizado  
- [ ] Nome de PR claro e descritivo  

---

## 👮 Políticas de Permissão do Repositório

Estrutura recomendada:

### Owners
- Ana Lúcia Nunes Lopes de Santa  
- 1 líder técnico (fictício)

Permissões:
- **Admin**: somente Owners

### Developers
- Permissão: **Write**  
- Não podem fazer push para `main`

### QA
- Permissão: **Triage ou Read**  
- Podem revisar PRs

### Bots
- **GitHub Actions** → Permissão: `write` em workflows  

Arquivo de permissão (padrão empresa):

```
.github/settings.yml

branches:
  - name: main
    protection:
      required_pull_request_reviews:
        required_approving_review_count: 1
      required_status_checks:
        strict: true
        contexts:
          - "build"
          - "test"
          - "sonarcloud"
      enforce_admins: true
      required_linear_history: true
      restrictions:
        users: []
        teams:
          - "developers"
```

---

# 📜 Licença
MIT

---

# 💼 Sobre o Projeto

Este repositório foi projetado para demonstrar:

- Senioridade em arquitetura distribuída  
- DevOps moderno (CI/CD + IaC + automações)  
- Backend forte (Java/Spring)  
- Cultura de qualidade e testes  
- Segurança corporativa  
- Estratégia e visão de negócio  



