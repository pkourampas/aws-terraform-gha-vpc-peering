variable "aws_main_vpc_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where the main VPC will be deployed (e.g., us-east-1)."
}

variable "aws_dr_vpc_region" {
  type        = string
  default     = "ca-central-1"
  description = "The AWS region where the disaster recovery (DR) VPC will be deployed (e.g., us-west-2)."
}

variable "aws_main_vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "CIDR block for the main VPC (e.g., 10.0.0.0/16)."
}

variable "aws_dr_vpc_cidr" {
  type        = string
  default     = "172.20.0.0/16"
  description = "CIDR block for the disaster recovery (DR) VPC (e.g., 10.1.0.0/16)."
}

variable "my_public_ipv4" {
  type        = string
  default     = "x.x.x.x/32"
  description = "The public IP address of your machine, used for allowing secure access (e.g., 203.0.113.10/32)."
}
