variable "aws_route_table_name" {
  description = "Name tag for the route table"
  type        = string
}
variable "aws_vpc_id" {
  description = "The ID of the VPC where the route table will be created"
  type        = string
}
variable "cidr_block" {
  description = "CIDR block for the internet gateway route (e.g., 0.0.0.0/0)"
  type        = string
}
variable "gateway_id" {
  description = "The ID of the internet gateway to use in the route"
  type        = string
}
variable "aws_subnet_id" {
  description = "The ID of the subnet to associate with the route table"
  type        = string
}
variable "aws_route_table_id" {
  description = "The ID of the route table to associate with the subnet"
  type        = string
}
variable "vpc_peering_connection_id" {
  description = "The ID of the VPC peering connection"
  type        = string
}
variable "vpc_peering_cidr_block" {
  description = "CIDR block of the peered VPC"
  type        = string
}
