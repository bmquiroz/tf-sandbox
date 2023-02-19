
resource "aws_route_table" "internet-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-igw"})
  )
}

resource "aws_route_table" "internet-nat" {
  vpc_id = aws_vpc.main-vpc.id
  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-inetnat"})
  )
}

resource "aws_route_table_association" "public-internet" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.internet-igw.id
}

# resource "aws_route_table_association" "tableau-internet" {
#   count          = 2
#   subnet_id      = aws_subnet.tableau[count.index].id
#   route_table_id = aws_route_table.internet-nat.id
# }

# resource "aws_route_table_association" "database-internet" {
#   count          = 2
#   subnet_id      = aws_subnet.database[count.index].id
#   route_table_id = aws_route_table.internet-nat.id
# }

resource "aws_route_table_association" "compute-internet" {
  count          = 2
  subnet_id      = aws_subnet.compute[count.index].id
  route_table_id = aws_route_table.internet-nat.id
}

resource "aws_route" "internet-nat" {
  count                  = 1
  route_table_id         = aws_route_table.internet-nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
}

resource "aws_route" "internet-igw" {
  route_table_id         = aws_route_table.internet-igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}