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



