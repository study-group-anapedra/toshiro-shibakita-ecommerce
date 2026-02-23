/*
  variables.tf (03-data/rds)

  O que faz:
  - Declara inputs do módulo RDS.
  - NÃO existe db_password: a senha é gerenciada automaticamente pelo RDS (AWS Secrets Manager).

  Quem consome:
  - main.tf do próprio módulo (aws_db_instance.this)

  Relevância:
  - Remove prompt de senha no CI/CD.
  - Garante padrão seguro e automatizado.
*/

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "database_security_group_id" {
  type = string
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  description = "Usuário master do RDS (senha será gerenciada automaticamente pela AWS)"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage_gb" {
  type    = number
  default = 20
}

variable "max_allocated_storage_gb" {
  type    = number
  default = 50
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}