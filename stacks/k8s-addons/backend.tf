/*
  backend.tf

  FUNÇÃO:
  Define onde o estado desta stack será salvo.

  IMPORTÂNCIA:
  Cada stack possui state isolado para evitar impacto cruzado.
  Isso permite destruir addons sem destruir o EKS.

  COMUNICA COM:
  ✔ S3 (state storage)
  ✔ DynamoDB (state lock)

  RELEVÂNCIA:
  Evita corrupção de state em ambientes multiusuário e CI/CD.
*/

terraform {

  backend "s3" {
    bucket         = "CHANGE-ME-TFSTATE-BUCKET"
    key            = "05-k8s-addons/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "CHANGE-ME-TFLOCK"
    encrypt        = true
  }

}