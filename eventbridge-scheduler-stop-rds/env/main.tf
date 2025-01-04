terraform {
  backend "s3" {
    bucket = "eventbridge-scheduler-stop-rds-terraform-prod"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

module "prod" {
  source           = "../src"
  db_database      = "foobar_database"
  db_username      = "admin"
  db_exec_username = "foobar_exec_username"
}