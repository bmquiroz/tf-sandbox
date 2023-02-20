resource "aws_db_instance" "db" {
  allocated_storage               = var.db_allocated_storage
  engine                          = var.db_engine
  engine_version                  = var.db_engine_version 
  identifier                      = var.db_identifier
  instance_class                  = var.db_instance_class
  storage_type                    = var.db_storage_type
  # iops                            = 10000
  name                            = var.db_name
  password                        = var.db_password
  username                        = var.db_username
  backup_retention_period         = 35
  multi_az                        = true
  vpc_security_group_ids          = [aws_security_group.db-sg.id]
  db_subnet_group_name            = aws_db_subnet_group.db-subnet-group.id
  storage_encrypted               = true
  # enabled_cloudwatch_logs_exports = var.rds_log
  # monitoring_interval             = 5
  # monitoring_role_arn             = var.rds_monitoring
  deletion_protection             = true

  tags = merge(
    var.tagging_standard, 
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db"})
  )
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-subnet-group")
  subnet_ids = var.aws_subnet_database_id

   tags = merge(
    var.tagging_standard, 
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-subnet-group"})
  )
}

# resource "aws_backup_vault" "db-destination" {
#   name        = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-vault")
#   kms_key_arn = var.aws_kms_key_tableau1_arn
# }

# resource "aws_backup_plan" "db-backup" {
#   name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-backup-plan")

#   rule {
#     rule_name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-backup-rule")

#     target_vault_name = aws_backup_vault.database_destination.id
#     schedule          = "cron(0 10 * * ? *)"
#     lifecycle {
#     delete_after = "7"
#     }
#   }
# }

# resource "aws_backup_selection" "db-backup" {
#   iam_role_arn = var.iam_for_backup_plan
#   name         = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-db-backup")
#   plan_id      = aws_backup_plan.database_rds.id

#   resources = [
#     aws_db_instance.provisioneddashboarddb.arn,
#     aws_rds_cluster.preferencedb.arn,
#     aws_rds_cluster.tableauexternaldb.arn,
#   ]
# }