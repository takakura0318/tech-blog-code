variable "db_database" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_exec_username" {
  type = string
}


variable "az_count" {
  description = "使用するAZの数"
  type        = number
  // AZ数を指定する
  default = 2
}

locals {
  // 利用可能なAZのリスト
  aws_az_list = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
  aws_az_codes = slice(local.aws_az_list, 0, var.az_count)

  // DBサーバ
  db_subnet_map = {
    for az in local.aws_az_codes :
    "db_${az}" => aws_subnet.db[az]
  }
  // Private Subnets
  private_subnet_map = merge(
    local.db_subnet_map,
  )

  db_subnet_ids = [
    for key, subnet in local.db_subnet_map : subnet.id
  ]
}