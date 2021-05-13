variable "vpc_cidr_block" {
  type = string
  default = "10.16.0.0/16"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.16.8.0/22"]
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["ap-south-1a"]
}

variable "public_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.16.0.0/22"]
}
