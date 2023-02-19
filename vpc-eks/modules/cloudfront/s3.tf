resource "aws_s3_bucket" "bucket" {
  bucket = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-s3")

  tags = {
    Name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-s3")
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}