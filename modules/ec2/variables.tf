variable "instance_ami" {
  description = "AMI ID used for launching the EC2 instance"
  type        = string
}
variable "associate_public_ip" {
  description = "Whether to associate a public IP with the EC2 instance"
  type        = bool
}
variable "instance_az" {
  description = "Availability Zone where the instance will be launched"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the EC2 (e.g., t3.micro)"
  type        = string
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}
variable "instance_subnet" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
}
variable "instance_tenancy" {
  description = "The tenancy option for the EC2 instance (default or dedicated)"
  type        = string
}
variable "vpc_sg_group_id" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}
variable "key_name" {
  description = "The name for the SSH key pair"
  sensitive   = true
  type        = string
}
variable "public_key_path" {
  description = "Path to the public key file used to access EC2"
  sensitive   = true
  type        = string
}
