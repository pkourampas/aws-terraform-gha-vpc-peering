variable "aws_main_vpc_region" {
  type = string
  default = "us-east-1"
}

variable "aws_dr_vpc_region" {
  type = string
  default = "ca-central-1"
}

variable "aws_main_vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "aws_dr_vpc_cidr" {
  type = string
  default = "172.20.0.0/16"
}

variable "my_public_ipv4" {
  type = string
}
