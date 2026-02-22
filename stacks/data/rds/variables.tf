/*
  stacks/data/rds/variables.tf

  O QUE É:
  - Declara as “entradas” aceitas por este módulo RDS.

  O QUE FAZ:
  - Define tipos, defaults e o que é obrigatório.

  COM QUEM CONVERSA:
  - Este módulo conversa com a stack "data" (root) que chama ele.
  - E indiretamente depende de outputs de networking/security (via remote_state no root).

  RELEVÂNCIA:
  - Evita prompts no GitHub Actions e evita erro de tipagem.
  - Mantém a stack previsível e reproduzível.
*/

variable "project_name" {
  type        = string
  description = "Nome base do projeto"
}

variable "environment" {
  type        = string
  description = "Ambiente (dev/staging/prod)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs das subnets privadas (vindas do networking via remote_state)"
}

variable "database_security_group_id" {
  type        = string
  description = "Security Group do RDS (vindo da stack security via remote_state)"
}

variable "db_name" {
  type        = string
  description = "Nome do database inicial no RDS"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Username master do RDS (se vazio, Terraform gera automaticamente)"
  default     = ""
}

variable "db_instance_class" {
  type        = string
  description = "Classe da instância RDS (ex: db.t3.micro)"
  default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
  type        = number
  description = "Storage inicial (GB)"
  default     = 20
}

variable "max_allocated_storage_gb" {
  type        = number
  description = "Storage máximo com autoscaling (GB)"
  default     = 50
}

variable "multi_az" {
  type        = bool
  description = "Habilita Multi-AZ (alta disponibilidade)"
  default     = false
}

variable "backup_retention_days" {
  type        = number
  description = "Dias de retenção de backup"
  default     = 7
}

variable "deletion_protection" {
  type        = bool
  description = "Protege contra deleção acidental do RDS"
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Se true, não cria snapshot final ao destruir (útil em laboratório)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags padrão"
  default     = {}
}