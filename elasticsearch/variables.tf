variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "num_of_instances" {
  type = number
}