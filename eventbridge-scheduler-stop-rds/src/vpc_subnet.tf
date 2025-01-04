// DB subnets
resource "aws_subnet" "db" {
  for_each = {
    for idx, az in local.aws_az_codes :
    az => {
      cidr_block        = cidrsubnet("10.0.0.0/16", 8, idx + 6)
      availability_zone = az
      name_suffix       = idx + 1
    }
  }

  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    "Name" = "db-subnet-${each.value.name_suffix}"
  }
}
