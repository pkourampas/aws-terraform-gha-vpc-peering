resource "aws_network_acl" "acl" {
  vpc_id = var.aws_vpc_id

  /** Dynamic blocks */
  dynamic "ingress" {
    for_each = var.nacl_ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.nacl_egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }
}

/** Associate the NACL with Subnet */
resource "aws_network_acl_association" "acl_association" {
  network_acl_id = aws_network_acl.acl.id
  subnet_id      = var.subnet_id
}
