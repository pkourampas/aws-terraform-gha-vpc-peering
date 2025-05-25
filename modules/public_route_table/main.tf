resource "aws_route_table" "route_table" {
  vpc_id = var.aws_vpc_id

  route = {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.aws_public_route_table_name
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id = var.aws_public_subnet_id
  route_table_id = var.aws_route_table_id
}
