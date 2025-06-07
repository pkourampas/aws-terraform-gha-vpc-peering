resource "aws_subnet" "subnet" {
  vpc_id                  = var.aws_vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = var.public_ip_on_launch

  tags = {
    Name = var.subnet_name
  }
}
