provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}

locals {
  Environment = "Test"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "default"
  tags = {
    Name        = "${local.Environment} VPC "
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "Test Internet Gateway"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "${local.Environment} Nat Gateway ${count.index}"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  count = length(var.public_subnets)

  vpc = true

  tags = {
    Name        = "${local.Environment} Nat Gateway ${count.index} Elastic IP"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}