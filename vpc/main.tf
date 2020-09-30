provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}

locals {
  Environment = "Test"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_map[terraform.workspace]}"
  instance_tenancy = "default"
  tags = {
    Name        = "${Environment} VPC "
    Environment = "${Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "Test Internet Gateway"
    Environment = "${Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags = {
    Name        = "Test NAT Gateway"
    Environment = "${Environment}"
    Creator     = "Terraform"
  }
}