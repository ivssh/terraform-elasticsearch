module "aws_vpc" {
  source = "./vpc"

}

provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}

module "elasticsearch-instance" {
  source = "./elasticsearch"

  vpc_id            = module.aws_vpc.vpc_id
  public_subnet_ids = module.aws_vpc.public_subnet_ids
  num_of_instances  = 1
  key_pair          = aws_key_pair.deployment.key_name
}

resource "aws_key_pair" "deployment" {
  key_name   = "test_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRovAxwLw4fdHsh7NXjyVM/TArx8/nQLmz/KfJRDOCI/DfU7xiTdfay/PgD5ZwMKVXyYlBAseBWZUmV1iUKu+GQJQBDbzU01nmWdt3IzJ540XZO5BdlkDIMgicPtfGAzT7YDkkE1GUGe5wWM8tcuaEaYOSgwKbEv8DKoUxcwN+9D67AkGIJ83HAXlbHIhiwZYn1l8GWRTHUWCiDQvp+v1PnM7/U54iQpKYT5ArjrqbfNGX5JMQVcZ3svLJNfY2nk9ryN6j+Xf9kUe3J6NXY5+69dzveHMX59iFY7lr5Bx88/7j04ZGJgTt47kFdxCCfO6Bvux66DPqBLbPN4PkyY95 abhilash@abhilash-bolla"
}