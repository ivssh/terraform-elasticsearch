variable "vpc_cidr_map" {
  type = "map"
  default = {
    "default"     = "10.16.0.0/16"
    "Development" = "10.16.0.0/16"
    "Staging"     = "10.17.0.0/16"
    "Production"  = "10.18.0.0/16"
  }
}