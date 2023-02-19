variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "aws_availability_zones" { type = list(any) }

variable "vpc_cidr" { type = string }

variable "log_s3" { type = string }

variable "ip_subnets" { type = map(any) }

variable "tagging_standard" { type = map(any) }