resource "aws_eip" "ngw-ip" {
  count = 1
  vpc   = true

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-inetnat"})
  )
}

resource "aws_nat_gateway" "ngw" {
  count = 1
  allocation_id = aws_eip.ngw-ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-inetnat"})
  )
}