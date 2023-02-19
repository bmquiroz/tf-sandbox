resource "aws_security_group" "db-sg" {
  name        = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-sg"
  description = "Security Group for RDS"
  vpc_id      = var.aws_vpc_main_id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "db-sg-egress" {
  security_group_id = aws_security_group.db-sg.id
  description       = "Allow all egress"
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg-general-ingress" {
  security_group_id = aws_security_group.db-sg.id
  description       = "Allow traffic from VPC CIDR to DB"

  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "TCP"
  cidr_blocks       = [var.vpc_cidr]
}