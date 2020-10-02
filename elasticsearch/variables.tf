variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "elastic_binary" {
  type = string
  default=""
}

variable "num_of_instances" {
  type = number
}

variable "elastic_password" {
  type = string
  default = "elastic123"
}