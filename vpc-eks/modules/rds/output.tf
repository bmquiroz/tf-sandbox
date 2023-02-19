output "db-sg" {
  value = aws_security_group.db-sg.id
}

output "db-endpoint" {
value = aws_db_instance.atlas-db.address

}

output "db-arn" {
  value = aws_db_instance.atlas-db.arn
}