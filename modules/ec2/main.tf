# ----- key to access ec2 -----
resource "aws_key_pair" "my_key" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "instance" {
  ami = var.instance_ami
  instance_type = var.instance_type
  availability_zone = var.instance_az
  associate_public_ip_address = var.associate_public_ip
  subnet_id = var.instance_subnet
  tenancy = var.instance_tenancy
  vpc_security_group_ids = var.vpc_sg_group_id
  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = var.instance_name
  }
}
