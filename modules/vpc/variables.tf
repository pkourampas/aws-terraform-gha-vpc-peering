variable "aws_vpc_cidr" {}
variable "aws_vpc_instance_tenancy" {}
variable "aws_vpc_enable_dns_hostnames" {
    type = bool
}
variable "aws_vpc_enable_dns_support" {
    type = bool  
}
variable "aws_vpc_tag_name" {
    type = string
}
