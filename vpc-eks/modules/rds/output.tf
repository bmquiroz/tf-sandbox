output "db-sg" {
  value = aws_security_group.db-sg.id
}

output "db-endpoint" {
value = aws_db_instance.db.address

}

output "db-arn" {
  value = aws_db_instance.db.arn
}