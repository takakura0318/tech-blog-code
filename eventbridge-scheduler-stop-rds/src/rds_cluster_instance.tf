resource "aws_rds_cluster_instance" "cluster_instances" {
  count                      = 2
  identifier                 = "aurora-cluster-${count.index}"
  cluster_identifier         = aws_rds_cluster.default.id
  instance_class             = "db.t3.medium"
  engine                     = aws_rds_cluster.default.engine
  engine_version             = aws_rds_cluster.default.engine_version
  auto_minor_version_upgrade = false
  apply_immediately          = false
  db_subnet_group_name       = aws_db_subnet_group.default.name
  // 例: 日本時間で月曜 02:00〜03:00 を想定
  preferred_maintenance_window = "Sun:17:00-Sun:18:00"
  monitoring_interval          = 0

  tags = {
    Name = "aurora-instance"
  }
}
