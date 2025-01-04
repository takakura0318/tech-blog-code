resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "DB"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = false
  }

  tags = {
    "Name" = "db-sg"
  }
}
