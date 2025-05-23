variable "public_ip_on_launch" {
  type = bool
}
variable "aws_vpc_id" {}
variable "availability_zone" {}
variable "subnet_cidr" {}
variable "subnet_name" {
  type = string
}
