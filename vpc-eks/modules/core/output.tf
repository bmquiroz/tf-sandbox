output "aws-vpc-main-id" {
  value = aws_vpc.main-vpc.id
}

output "aws-subnet-public-id" {
  value = aws_subnet.public.*.id
}

output "aws-subnet-database-id" {
  value = aws_subnet.database.*.id
}

output "aws-subnet-compute-id" {
  value = aws_subnet.compute.*.id
}

# output "aws-subnet-tableau-id" {
#   value = aws_subnet.tableau.*.id
# }

output "aws-route-table-id-public" {
  value = aws_route_table.internet-igw.*.id
}

output "aws-route-table-id-private" {
  value = aws_route_table.internet-nat.*.id
}

output "eks-sg-id" {
  value = aws_security_group.eks-sg.id
}