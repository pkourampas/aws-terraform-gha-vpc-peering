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
