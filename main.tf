provider "aws" {
  region = var.aws_main_vpc_region
}

provider "aws" {
  alias = "dr"
  region = var.aws_dr_vpc_region
}

# ----- Create Main VPC -----
module "vpc_main" {
  source = "./modules/vpc"
  aws_vpc_cidr = var.aws_main_vpc_cidr
  aws_vpc_instance_tenancy = local.vpc_tenancy
  aws_vpc_enable_dns_hostnames = true
  aws_vpc_enable_dns_support = true
  aws_vpc_tag_name = "main vpc"
}

# ----- Create Dr VPC -----
module "vpc_dr" {
  source = "./modules/vpc"
  aws_vpc_cidr = var.aws_dr_vpc_cidr
  aws_vpc_instance_tenancy = local.vpc_tenancy
  aws_vpc_enable_dns_hostnames = true
  aws_vpc_enable_dns_support = true
  aws_vpc_tag_name = "dr vpc"
  
  providers = {
    aws = aws.dr
  }
}

# ----- Create Main VPC IGW -----
module "main_vpc_igw" {
  source = "./modules/igw"
  aws_vpc_id = module.vpc_main.aws_vpc_id
  aws_vpc_igw_name = "main vpc igw"
}


# ----- Create a Public Subnet in Main VPC -----

# Allow access to the list of AWS Availability zones
data "aws_availability_zones" "main" {
  state = "available"
}

module "main_vpc_public_subnet" {
  source = "./modules/subnets"
  aws_vpc_id = module.vpc_main.aws_vpc_id
  availability_zone = data.aws_availability_zones.main.names[0]
  subnet_cidr = cidrsubnet(module.vpc_main.aws_vpc_cidr, 8, 0)
  public_ip_on_launch = true
  subnet_name = "main vpc public subnet"
}

# ----- Create a Private Subnet in Dr VPC -----

# Allow access to the list of AWS Availability zones
data "aws_availability_zones" "dr" {
  provider = aws.dr
  state = "available"
}

module "dr_vpc_private_subnet" {
  source = "./modules/subnets"
  aws_vpc_id = module.vpc_dr.aws_vpc_id
  availability_zone = data.aws_availability_zones.dr.names[0]
  subnet_cidr = cidrsubnet(module.vpc_dr.aws_vpc_cidr, 8, 0)
  public_ip_on_launch = false
  subnet_name = "dr vpc private subnet"

  providers = {
    aws = aws.dr
  }

}

# ----- Main vpc route table -----
module "main_vpc_public_route_table" {
  source = "./modules/route_table"
  aws_vpc_id = module.vpc_main.aws_vpc_id
  cidr_block = "0.0.0.0/0"
  gateway_id = module.main_vpc_igw.vpc_igw_id
  aws_public_route_table_name = "main vpc public route table"
  aws_public_subnet_id = module.main_vpc_public_subnet.subnet_id
  aws_route_table_id = module.main_vpc_public_route_table.route_table_id
}

# ----- Dr vpc route table -----
module "dr_vpc_private_route_table" {
  source = "./modules/route_table"
  aws_vpc_id = module.vpc_dr.aws_vpc_id
  cidr_block = var.aws_dr_vpc_cidr
  gateway_id = "local"
  aws_public_route_table_name = "dr vpc private route table"
  aws_public_subnet_id = module.dr_vpc_private_subnet.subnet_id
  aws_route_table_id = module.dr_vpc_private_route_table.route_table_id

  providers = {
    aws = aws.dr
  }

}

# ----- main vpc Security Group & Instance -----
module "main_vpc_sg" {
  source = "./modules/sg"
  sg_name = "ec2-instance-sg"
  sg_desc = "SG for EC2 instance in the public subnet of the main VPC"
  aws_vpc_id = module.vpc_main.aws_vpc_id
  security_group_name_tag = "main_vpc_public_subnet_sg"
  
  ingress_rules = [
    { from_port = 80, to_port = 80, ip_protocol = "tcp", cidr_block = var.my_public_ipv4 },
    { from_port = 22, to_port = 22, ip_protocol = "tcp", cidr_block = var.my_public_ipv4 },
    {from_port = 8, to_port = 0, ip_protocol = "icmp", cidr_block = var.my_public_ipv4 }    # 8 echo, 0 echo reply url: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  ]

  egress_rules = [
    { from_port = 0, to_port = 0, ip_protocol = "-1", cidr_block = var.my_public_ipv4 }
  ]
}

## ----- EC2 Instance -----

# ----- AWS AMI FILTER -----
data "aws_ami" "main_vpc_latest_amazon_linux" {
  most_recent = true

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}


module "main_instance" {
  source = "./modules/ec2"
  instance_ami = data.aws_ami.main_vpc_latest_amazon_linux.id
  instance_type = "t2.small"
  instance_az = data.aws_availability_zones.main.names[0]
  associate_public_ip = true
  instance_subnet = module.main_vpc_public_subnet.subnet_id
  instance_tenancy = "default"
  vpc_sg_group_id = [module.main_vpc_sg.security_group_id]
  instance_name = "main vpc public subnet instance" 
  key_name = "my_ec2_key"
  public_key_path = "~/.ssh/id_rsa.pub"
}


# ----- DR VPC EC2 Instance -----

# ----- DR vpc Security Group & Instance -----
module "dr_vpc_sg" {
  source = "./modules/sg"
  sg_name = "private-ec2-instance-sg"
  sg_desc = "SG for EC2 instance in the private subnet of the dr VPC"
  aws_vpc_id = module.vpc_dr.aws_vpc_id
  security_group_name_tag = "dr_vpc_private_subnet_sg"
  
  ingress_rules = [
    { from_port = 80, to_port = 80, ip_protocol = "tcp", cidr_block = module.main_vpc_public_subnet.subnet_cidr },
    { from_port = 22, to_port = 22, ip_protocol = "tcp", cidr_block = module.main_vpc_public_subnet.subnet_cidr },
    {from_port = 8, to_port = 0, ip_protocol = "icmp", cidr_block = module.main_vpc_public_subnet.subnet_cidr }    # 8 echo, 0 echo reply url: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  ]

  egress_rules = [
    { from_port = 0, to_port = 0, ip_protocol = "-1", cidr_block = module.main_vpc_public_subnet.subnet_cidr }
  ]
}


# --- AWS AMI FILTER ---
data "aws_ami" "dr_vpc_latest_amazon_linux" {
  most_recent = true

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]

  provider = aws.dr
}


module "dr_instance" {
  source = "./modules/ec2"
  instance_ami = data.aws_ami.dr_vpc_latest_amazon_linux.id
  instance_type = "t2.small"
  instance_az = data.aws_availability_zones.dr.names[0]
  associate_public_ip = false
  instance_subnet = module.dr_vpc_private_subnet.subnet_id
  instance_tenancy = "default"
  vpc_sg_group_id = [module.dr_vpc_sg.security_group_id] ## Need to create a vpc sg
  instance_name = "dr vpc private subnet instance" 
  key_name = "my_ec2_key"
  public_key_path = "~/.ssh/id_rsa.pub"

  providers = {
    aws = aws.dr
  }
}



# ----- VPC Peering -----
data "aws_caller_identity" "peer" {       # Get the account id of peer connection
  provider = aws.dr
}

resource "aws_vpc_peering_connection" "main_vpc_peer_requestor" {
  vpc_id = module.vpc_main.aws_vpc_id
  peer_vpc_id = module.vpc_dr.aws_vpc_id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region = var.aws_dr_vpc_region
  auto_accept = false
  
  tags = {
    Side = "Requester"
  }

}

resource "aws_vpc_peering_connection_accepter" "dr_vpc_peer_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.main_vpc_peer_requestor.id
  auto_accept = true

  provider = {
    aws = aws.dr
  }

  tags = {
    Side = "Accepter"
  }

}
