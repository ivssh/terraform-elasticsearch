module "aws_vpc" {
  source = "./vpc"
  
}

module "elasticsearch-instance" {
  source = "./elasticsearch"
}