resource "aws_route_table" "route_table" {
  vpc_id = var.aws_vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }

  route {
    cidr_block                = var.vpc_peering_cidr_block
    vpc_peering_connection_id = var.vpc_peering_connection_id
  }

  tags = {
    Name = var.aws_route_table_name
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = var.aws_subnet_id
  route_table_id = var.aws_route_table_id
}
