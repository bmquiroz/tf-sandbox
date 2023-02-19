resource "aws_security_group" "eks-sg" {
  name        = "${var.application}-${var.uai}-${lookup(var.tagging_standard,"deployment")}-eks-sg"
  description = "Security Group for EKS"
  vpc_id      = aws_vpc.main-vpc.id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "eks-sg-egress" {
  security_group_id = aws_security_group.eks-sg.id
  description       = "Allow all egress"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow HTTP traffic (TCP/80) from public subnet
# resource "aws_security_group_rule" "eks-sg-https-ingress" {
#   security_group_id = aws_security_group.eks-sg.id
#   description       = "Allow HTTP igress from public subnet"
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "all"
#   cidr_blocks       = [var.vpc_cidr]
# }

resource "aws_security_group_rule" "eks-sg-ingress" {
  security_group_id = aws_security_group.eks-sg.id
  description       = "Allow all igress from VPC CIDR"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.vpc_cidr]
}