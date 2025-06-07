variable "aws_vpc_id" {
  description = "The ID of the VPC to associate with the Internet Gateway"
  type        = string
}

variable "aws_vpc_igw_name" {
  description = "The Name tag to assign to the Internet Gateway"
  type        = string
}
