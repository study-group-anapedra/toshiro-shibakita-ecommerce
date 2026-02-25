/*
  stacks/k8s-addons/variables.tf

  FUNÇÃO:
  - Define os inputs necessários para o Terraform conectar ao cluster EKS.
  - Permite localizar os arquivos de estado (tfstate) das stacks anteriores no S3.

  COMUNICA COM:
  ✔ compute-eks (para pegar as credenciais do cluster)
  ✔ networking (caso precise de IDs de subnets para o Load Balancer)
  ✔ security (para associar Security Groups ao Controller)

  IMPORTANTE:
  Sem estas variáveis, o Remote State e a autenticação do Kubernetes falham.
*/

variable "aws_region" {
  type        = string
  description = "Região da AWS (ex: us-east-1)"
}

variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 que armazena os arquivos .tfstate"
}

variable "environment" {
  type        = string
  description = "Ambiente da stack (prod)"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto para identificação e tags"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags adicionais para os recursos de IAM/K8S"
}