output "vpc_id" {
  value = concat(aws_vpc.vpc.*.id, [""])[0]
}

output "public_subnet_ids" {
  value = tolist(aws_subnet.public.*.id)
}
