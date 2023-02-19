resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = lookup(var.ip_subnets, "subnet_public${count.index}")
  map_public_ip_on_launch = false
  availability_zone       = element(var.aws_availability_zones, count.index)

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-public_subnet${count.index}"})
  )
}

resource "aws_subnet" "database" {
  count                   = 2
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = lookup(var.ip_subnets, "subnet_database${count.index}")
  map_public_ip_on_launch = false
  availability_zone       = element(var.aws_availability_zones, count.index)

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-database${count.index}"})
  )
}

resource "aws_subnet" "compute" {
  count                   = 2
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = lookup(var.ip_subnets, "subnet_compute${count.index}")
  map_public_ip_on_launch = false
  availability_zone       = element(var.aws_availability_zones, count.index)

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-compute${count.index}"})
  )
}

# resource "aws_subnet" "tableau" {
#   count                   = 2
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = lookup(var.ip_subnets, "subnet-tableau${count.index}")
#   map_public_ip_on_launch = false
#   availability_zone       = element(var.aws_availability_zones, count.index)

#   tags = merge(
#     var.tagging_standard,
#     map("Name", "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-tableau${count.index}")
#   )
# }