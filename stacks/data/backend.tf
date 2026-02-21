/*
  backend.tf (stack data)

  O que este arquivo faz?
  - Define onde o Terraform vai armazenar o STATE da stack "data".

  Por que usar S3 + DynamoDB?
  ✔ Evita state local (terraform.tfstate no computador).
  ✔ Permite trabalho em equipe.
  ✔ Evita corrupção do state (lock via DynamoDB).
  ✔ CI/CD pode usar o mesmo state com segurança.

  IMPORTANTE:
  - Cada stack possui seu próprio state isolado.
  - Isso reduz o "blast radius".
  - Se a stack data quebrar, networking e security continuam intactas.

  Bucket:
  - Criado na stack 00-bootstrap.

  Key:
  - Deve refletir exatamente o nome da pasta da stack.
  - Sua pasta chama "data", então:
        data/terraform.tfstate

  DynamoDB:
  - Mesmo lock table usada nas outras stacks.

  Encrypt:
  - Criptografa automaticamente o state no S3.
*/

terraform {

  backend "s3" {

    # Bucket criado no bootstrap
    bucket = "toshiro-ecommerce-dev-tfstate"

    # Caminho do state dentro do bucket (nome da pasta)
    key = "data/terraform.tfstate"

    # Região AWS
    region = "us-east-1"

    # Lock para impedir dois applies ao mesmo tempo
    dynamodb_table = "toshiro-ecommerce-dev-tfstate-lock"

    # Criptografia no S3
    encrypt = true
  }

}
