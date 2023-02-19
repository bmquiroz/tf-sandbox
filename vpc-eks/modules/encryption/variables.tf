# Core Deployment Information
variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "aws_availability_zones" { type = list(any) }

variable "taggingstandard" { type = map(any) }

variable "trusted_ssh_key" { type = string }

variable "account_id" {type=string}