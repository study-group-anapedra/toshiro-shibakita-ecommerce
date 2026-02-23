variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente (dev/prod)"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# =========================================================
# Backend e Remote State (ALINHADO COM WORKFLOW)
# =========================================================
variable "remote_backend_bucket_name" {
  type        = string
  description = "Nome do bucket S3 onde estão os states"
}

variable "remote_backend_dynamodb_table" {
  type    = string
  default = null
}

# As chaves abaixo agora possuem os caminhos padrão usados pelo seu workflow
variable "remote_state_key_networking" {
  type        = string
  description = "Caminho do state de networking"
  default     = "01-networking/terraform.tfstate"
}

variable "remote_state_key_security" {
  type        = string
  description = "Caminho do state de security"
  default     = "security/terraform.tfstate"
}

# =========================================================
# PostgreSQL - RDS (AWS Managed)
# =========================================================
variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage_gb" { type = number; default = 20 }
variable "max_allocated_storage_gb" { type = number; default = 50 }
variable "multi_az" { type = bool; default = false }
variable "backup_retention_days" { type = number; default = 7 }
variable "deletion_protection" { type = bool; default = false }
variable "skip_final_snapshot" { type = bool; default = true }

# =========================================================
# Outros
# =========================================================
variable "vpc_cidr" { type = string; default = null }
variable "tags" { type = map(string); default = {} }