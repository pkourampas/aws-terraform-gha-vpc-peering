resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr
  instance_tenancy     = var.aws_vpc_instance_tenancy
  enable_dns_hostnames = var.aws_vpc_enable_dns_hostnames
  enable_dns_support   = var.aws_vpc_enable_dns_support

  tags = {
    Name = var.aws_vpc_tag_name
  }
}
