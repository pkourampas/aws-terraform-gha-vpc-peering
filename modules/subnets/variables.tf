variable "public_ip_on_launch" {
  description = "Whether to auto-assign public IPs to instances launched in this subnet"
  type        = bool
}
variable "aws_vpc_id" {
  description = "The ID of the VPC where the subnet will be created"
  type        = string
}
variable "availability_zone" {
  description = "The availability zone where the subnet will reside"
  type        = string
}
variable "subnet_cidr" {
  description = "The CIDR block to assign to the subnet"
  type        = string
}
variable "subnet_name" {
  description = "The Name tag to assign to the subnet"
  type        = string
}
