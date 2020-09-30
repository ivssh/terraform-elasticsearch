resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = var.private_subnets[count.index]
  availability_zone               = element(var.azs, count.index)

  tags = {
    Name        = "Main ${local.Environment} Private Subnet ${count.index}"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = element(concat(var.public_subnets, [""]), count.index)
  availability_zone               = element(var.azs, count.index)
  
  tags = {
    Name        = "Main ${local.Environment} Public Subnet ${count.index}"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table" "igw_rt" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_internet_gateway.igw.*.id, count.index)
  }

  tags = {
    Name        = "${local.Environment} Internet Gateway Route Table"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table" "nat_rt" {
  count = length(var.private_subnets)
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }

  tags = {
    Name        = "${local.Environment} NAT Gateway Route Table ${count.index}"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}