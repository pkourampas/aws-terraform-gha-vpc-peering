provider "aws" {
  alias = "main"
  region = var.aws_main_vpc_region
}

provider "aws" {
  alias = "dr"
  region = var.aws_dr_vpc_region 
}

# ----- Create Main VPC -----
module "vpc_main" {
  source = "../modules/vpc/vpc"
  aws_vpc_cidr = var.aws_main_vpc_cidr
  aws_vpc_instance_tenancy = local.vpc_tenancy
  aws_vpc_enable_dns_hostnames = true
  aws_vpc_enable_dns_support = true
  aws_vpc_tag_name = "main vpc"

  providers = {
    aws = aws.main
  }
}

# ----- Create Dr VPC -----
module "vpc_dr" {
  source = "../modules/vpc/vpc"
  aws_vpc_cidr = var.aws_dr_vpc_cidr
  aws_vpc_instance_tenancy = local.vpc_tenancy
  aws_vpc_enable_dns_hostnames = true
  aws_vpc_enable_dns_support = true
  aws_vpc_tag_name = "dr vpc"
  
  providers = {
    aws = aws.dr
  }
}
