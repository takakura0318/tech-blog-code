resource "random_password" "db_initial_password" {
  length           = 32
  special          = true
  override_special = "_%?"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier          = "aurora-cluster"
  engine                      = "aurora-mysql"
  engine_version              = "8.0.mysql_aurora.3.08.0"
  availability_zones          = local.aws_az_codes
  port                        = 3306
  database_name               = var.db_database
  master_username             = "admin"
  master_password             = random_password.db_initial_password.result
  allow_major_version_upgrade = false
  backup_retention_period     = 5

  preferred_backup_window         = "14:00-14:30"
  preferred_maintenance_window    = "Sun:17:00-Sun:18:00"
  apply_immediately               = false
  skip_final_snapshot             = true
  vpc_security_group_ids          = [aws_security_group.db.id]
  db_subnet_group_name            = aws_db_subnet_group.default.name
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
  storage_encrypted               = false
  deletion_protection             = false

#  lifecycle {
#    prevent_destroy = true
#    ignore_changes  = [master_password, engine_version, availability_zones]
#  }

  tags = {
    Name = "aurora-cluster"
  }
}
