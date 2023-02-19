variable "random_string" { type = string }

variable "account_id" { type = string }

variable "cat_url" { type = string }

variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "tagging_standard" { type = map(any) }

variable "nlb_endpoint_arns" { type = list(any) }