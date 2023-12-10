# resource "aws_network_interface" "bastion" {
#   count = lookup(var.bastion_ec2_settings, "instance_count")
#   subnet_id       = element(var.aws_subnet_public_id, count.index % length(var.aws_subnet_public_id))
#   private_ips     = [cidrhost(lookup(var.ip_subnets, "subnet_public${count.index % length(var.aws_subnet_public_id)}"), 4 + floor(count.index / length(var.aws_subnet_public_id)))]
#   security_groups = [aws_security_group.bastion.id]

#   tags = merge(
#     var.tagging_standard,
#     map("Name", "${lookup(var.tagging_standard, "deployment")}-bastion${count.index + 1}")
#   )
# }

resource "aws_iam_role" "bastion-role" {
  name = "rc-its-poc-ssm-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastion-profile" {
  name = "rcits-poc-ssm-ec2"
  role = "${aws_iam_role.bastion-role.id}"
}

resource "aws_iam_policy_attachment" "bastion-role-attach1" {
  name       = "bastion-ssm-attachment"
  roles      = [aws_iam_role.bastion-role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "bastion-role-attach2" {
  name       = "bastion-ssm-attachment"
  roles      = [aws_iam_role.bastion-role.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_instance" "bastion" {
  count = lookup(var.bastion_ec2_settings, "instance_count")
  ami                  = lookup(var.bastion_ec2_settings, "ami")
  instance_type        = lookup(var.bastion_ec2_settings, "instance_type")
  key_name             = var.aws_key_pair
  monitoring           = true
  ebs_optimized        = true
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id            = "${element(var.aws_subnet_compute_id,0)}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion-profile.id}"
  user_data            = "${file("bootstrap.sh")}"

  # metadata_options {
  #   http_endpoint = "enabled"
  #   http_tokens   = "required"
  # }

  root_block_device {
    # encrypted   = true
    # kms_key_id  = var.aws_kms_key_tableau1_arn
    volume_size = lookup(var.bastion_ec2_settings, "volume_size")
    volume_type = lookup(var.bastion_ec2_settings, "volume_type")
  }

  # network_interface {
  #   network_interface_id = aws_network_interface.bastion[count.index].id
  #   device_index         = 0
  # }
  tags = merge(
    var.tagging_standard, 
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-bastion${count.index + 1}"})
  )
}