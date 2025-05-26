resource "aws_security_group" "sg" {
  name = var.sg_name
  description = var.sg_desc
  vpc_id = var.aws_vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.sg.id

  cidr_ipv4         = each.value.cidr_block
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

}


resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  security_group_id = aws_security_group.sg.id

  cidr_ipv4   = each.value.cidr_block
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port

}
