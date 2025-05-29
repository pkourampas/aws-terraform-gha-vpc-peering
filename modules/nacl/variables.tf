variable "aws_vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "subnet_id" {
  description = "List of subnet IDs to associate with the ACL"
  type = string
}

variable "nacl_ingress_rules" {
  description = "List of Network Access Control List ingress rules"
  type = list(object({
    protocol = string
    rule_no = number
    action = string
    cidr_block = string
    from_port = number
    to_port = number    
  }))
}

variable "nacl_egress_rules" {
  description = "List of Network Access Control List egress rules"
  type = list(object({
    protocol = string
    rule_no = number
    action = string
    cidr_block = string
    from_port = number
    to_port = number  
  }))
}
