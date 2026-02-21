/*
  variables.tf

  FUNÇÃO:
  Inputs necessários para conectar ao EKS
  e localizar os states anteriores.

  COMUNICA COM:

  ✔ compute-eks
  ✔ networking
  ✔ security

  IMPORTANTE:
  Remote State depende disso.
*/

variable "aws_region" {
  type = string
}

variable "remote_backend_bucket_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}