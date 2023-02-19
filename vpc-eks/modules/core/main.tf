resource "aws_vpc" "main-vpc" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = false
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-vpc"})
  )
}

# resource "aws_flow_log" "main-vpc-flow-logs" {
#   log_destination      = var.log_s3
#   log_destination_type = "s3"
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.main-vpc.id
# }

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.main-vpc.id
}