variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
}
variable "aws_vpc_instance_tenancy" {
  description = "The tenancy option for instances launched into the VPC (default or dedicated)"
  type        = string
}
variable "aws_vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
}
variable "aws_vpc_enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
}
variable "aws_vpc_tag_name" {
  description = "The Name tag for the VPC"
  type        = string
}
