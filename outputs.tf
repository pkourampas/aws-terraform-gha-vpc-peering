output "main_vpc_ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance launched in the main VPC"
  value       = module.main_instance.public_ip
}

output "main_vpc_ec2_isntance_private_ip" {
  description = "The private IP address of the EC2 instance launched in the main VPC"
  value       = module.main_instance.private_ip
}

output "dr_vpc_ec2_instance_private_ip" {
  description = "The private IP address of the EC2 instance launched in the DR (Disaster Recovery) VPC"
  value       = module.dr_instance.private_ip
}

output "dr_vpc_instance_type" {
  description = "The instance type of the EC2 instance deployed in the DR VPC"
  value       = module.dr_instance.instance_type
}
