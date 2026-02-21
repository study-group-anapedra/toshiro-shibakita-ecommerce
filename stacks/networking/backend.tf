/*
  backend.tf

  Este arquivo configura o backend remoto do Terraform.

  Em vez de salvar o terraform.tfstate localmente,
  ele será armazenado de forma centralizada no S3.

  O DynamoDB é usado como mecanismo de LOCK,
  impedindo que duas pessoas ou pipelines executem
  "terraform apply" ao mesmo tempo.

  Isso é padrão enterprise e permite:
  - Trabalho em equipe
  - CI/CD seguro
  - Versionamento do state
  - Prevenção de corrupção do estado

  bucket         → Onde o state é armazenado
  key            → Caminho do state dentro do bucket
  region         → Região AWS
  dynamodb_table → Tabela de lock
  encrypt        → Criptografia do state no S3
*/

terraform {
  backend "s3" {
    bucket         = "toshiro-ecommerce-dev-tfstate"
    key            = "01-networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"
    encrypt        = true
  }
}

