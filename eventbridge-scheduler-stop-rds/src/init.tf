terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "use1"
}