variable "sg_name" {
  description = "The name of the security group"
  type        = string
}

variable "sg_desc" {
  description = "The description of the security group"
  type        = string
}

variable "aws_vpc_id" {
  description = "The ID of the VPC where the security group is created"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_block  = string
  }))
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_block  = string
  }))
}

variable "security_group_name_tag" {
  description = "The Name tag for the security group"
  type        = string
}
