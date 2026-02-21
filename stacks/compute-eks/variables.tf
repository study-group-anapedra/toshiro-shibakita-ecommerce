/*
  variables.tf (stack 04-compute-eks)
  FUNÇÃO: Declarar parâmetros de entrada.
*/

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "remote_backend_bucket_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}