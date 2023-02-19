variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "aws_availability_zones" { type = list(any) }

variable "subnet_ids" { type = list(any) }

variable "vpc_id" { type = string }

variable "instance_type" { type = string }

variable "tagging_standard" { type = map(any) }

variable "security_group" { type = string }