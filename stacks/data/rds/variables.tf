/*
  variables.tf (03-data/rds)
  
  O QUE FAZ:
  Define os tipos de dados aceitos. Note que 'db_password' não é mais 
  exigida externamente, pois o main.tf a gera sozinho.
*/

variable "project_name" { type = string }
variable "environment"  { type = string }
variable "vpc_id"       { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "database_security_group_id" { type = string }

variable "db_name"     { type = string; default = "appdb" }
variable "db_username" { type = string; default = "dbadmin" }

# Esta variável agora pode ficar vazia ou ser removida, 
# pois usamos a geração automática no main.tf
variable "db_password" {
  type      = string
  default   = "" 
  sensitive = true
}

variable "db_instance_class"     { type = string; default = "db.t3.micro" }
variable "allocated_storage_gb" { type = number; default = 20 }
variable "max_allocated_storage_gb" { type = number; default = 50 }
variable "multi_az"              { type = bool;   default = false }
variable "backup_retention_days" { type = number; default = 7 }
variable "deletion_protection"   { type = bool;   default = false }
variable "skip_final_snapshot"   { type = bool;   default = true }
variable "tags"                  { type = map(string); default = {} }