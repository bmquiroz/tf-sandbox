/*output "aws_eip_bastion_public_ip" {
  value = aws_eip.bastion.*.public_ip
}*/

output "bastion-sg" {
  value = aws_security_group.bastion-sg.id
}