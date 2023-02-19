variable "db_name" {
  type        = string
  description = "DB name"
}

variable "db_identifier" {
  type        = string
  description = "DB identifier"
}

variable "db_engine" {
  type        = string
  description = "Engine type, example values mysql, postgres"
}

variable "db_engine_version" {
  description = "Engine version"
  type        = string
}

variable "db_username" {
  type        = string
  description = "User name"
}

variable "db_password" {
  description = "Password, provided through env variables"
  type        = string
}

variable "db_instance_class" { type = string }

variable "db_storage_type" { type = string }

variable "db_allocated_storage" { type = string }

variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "vpc_cidr" { type = string }

variable "tagging_standard" { type = map(any) }

variable "aws_subnet_database_id" { type = list(any) }

variable "aws_vpc_main_id" { type = string }

# variable "iam_for_backup_plan" { type = string }

# variable "aws_kms_key_arn" { type = string }

# variable "rds_log" { type = list(any) }

# variable "rds_monitoring" { type = string }