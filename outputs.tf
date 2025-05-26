output "main_vpc_ec2_instance_public_ip" {
  value = module.main_instance.public_ip
}

output "main_vpc_ec2_isntance_private_ip" {
  value = module.main_instance.private_ip
}
