variable "instance_ami" {}
variable "associate_public_ip" {
  type = bool
}
variable "instance_az" {}
variable "instance_type" {}
variable "instance_name" {}
variable "instance_subnet" {}
variable "instance_tenancy" {}
variable "vpc_sg_group_id" {
  type = list(string)
}
variable "key_name" {
  sensitive = true
  type      = string
}
variable "public_key_path" {
  sensitive = true
  type      = string
}
