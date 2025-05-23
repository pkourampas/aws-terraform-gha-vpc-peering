output "subnet_az" {
  value = aws_subnet.subnet.availability_zone
}

output "subnet_cidr" {
  value = aws_subnet.subnet.cidr_block
}

output "subnet_vpc_assignment" {
  value = aws_subnet.subnet.vpc_id  
}
