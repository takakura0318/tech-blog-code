resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = local.db_subnet_ids

  tags = {
    Name = "db-subnet-group"
  }
}