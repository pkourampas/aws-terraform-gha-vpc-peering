variable "sg_name" {
  type = string
}

variable "sg_desc" {
  type = string
}

variable "aws_vpc_id" {}

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

variable "security_group_name_tag" {}
