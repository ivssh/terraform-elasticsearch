provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}

resource "random_id" "index" {
  byte_length = 2
}

locals {
  Environment             = "Test"
  subnet_ids_list         = var.public_subnet_ids
  subnet_ids_random_index = random_id.index.dec % length(local.subnet_ids_list)
}

resource "aws_instance" "elasticsearch_instance" {
  count                  = "${var.num_of_instances}"
  ami                    = "ami-009110a2bf8d7dd0a"
  instance_type          = "t3.micro"
  subnet_id              = element(var.public_subnet_ids, local.subnet_ids_random_index)
  vpc_security_group_ids = ["${aws_security_group.elasticsearch_security_group.id}"]
  key_name               = var.key_pair

  tags = {
    Name        = "${local.Environment} Elasticsearch instance ${count.index}"
    Environment = "${local.Environment}"
    Creator     = "Terraform"
  }
}