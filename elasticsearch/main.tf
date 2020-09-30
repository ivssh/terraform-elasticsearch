provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}

locals {
  Environment = "Test"
}