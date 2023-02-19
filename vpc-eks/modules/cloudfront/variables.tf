variable "env" { type = string }

variable "application" { type = string }

variable "uai" { type = string }

variable "aws_region" { type = string }

variable "tagging_standard" { type = map(any) }

variable "domain_cnames" { type = list(any) }

variable "domain_name" { type = string }

variable "nlb_endpoint" { type = string }

variable "nlb_subnet_ids" { type = list(any) }

# variable "alb_sg_ids" { type = string }