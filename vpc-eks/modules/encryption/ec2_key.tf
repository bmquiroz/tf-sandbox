resource "aws_key_pair" "main2" {
  key_name   = "${lookup(var.taggingstandard, "deployment")}-SSHKey"
  public_key = var.trusted_ssh_key

  tags = merge(
    var.taggingstandard,
    map("Name", "${lookup(var.taggingstandard, "deployment")}-SSHKey")
  )
}