resource "aws_security_group" "bastion-sg" {
  name = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-bastion-sg"
  lifecycle {
    create_before_destroy = "true"
  }
  description = "Security Group for bastion servers"
  vpc_id      = var.aws_vpc_main_id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "bastion-sg-egress" {
  security_group_id = aws_security_group.bastion-sg.id
  description       = "Allow all egress"

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-sg-general-ingress" {
  security_group_id = aws_security_group.bastion-sg.id
  description       = "Allow traffic from VPC CIDR to bastion"

  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.vpc_cidr]
}

# resource "aws_security_group_rule" "db-bastion" {
#   security_group_id = aws_security_group.bastion.id
#   description       = "Allow Traffic from bastion to DB"

#   type              = "ingress"
#   from_port         = 3389
#   to_port           = 3389
#   protocol          = "TCP"
#   source_security_group_id = aws_security_group.bastion.id
# }

# resource "aws_security_group_rule" "db-bastion-ssh" {
#   security_group_id = aws_security_group.bastion.id
#   description       = "Allow Traffic from bastion to dbssh"

#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "TCP"
#   source_security_group_id = aws_security_group.bastion.id
# }