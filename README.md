<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.98.0 |
| <a name="provider_aws.dr"></a> [aws.dr](#provider\_aws.dr) | 5.98.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dr_instance"></a> [dr\_instance](#module\_dr\_instance) | ./modules/ec2 | n/a |
| <a name="module_dr_vpc_private_route_table"></a> [dr\_vpc\_private\_route\_table](#module\_dr\_vpc\_private\_route\_table) | ./modules/route_table | n/a |
| <a name="module_dr_vpc_private_subnet"></a> [dr\_vpc\_private\_subnet](#module\_dr\_vpc\_private\_subnet) | ./modules/subnets | n/a |
| <a name="module_dr_vpc_private_subnet_nacl_rules"></a> [dr\_vpc\_private\_subnet\_nacl\_rules](#module\_dr\_vpc\_private\_subnet\_nacl\_rules) | ./modules/nacl | n/a |
| <a name="module_dr_vpc_sg"></a> [dr\_vpc\_sg](#module\_dr\_vpc\_sg) | ./modules/sg | n/a |
| <a name="module_main_instance"></a> [main\_instance](#module\_main\_instance) | ./modules/ec2 | n/a |
| <a name="module_main_vpc_igw"></a> [main\_vpc\_igw](#module\_main\_vpc\_igw) | ./modules/igw | n/a |
| <a name="module_main_vpc_ps_nacl_rules"></a> [main\_vpc\_ps\_nacl\_rules](#module\_main\_vpc\_ps\_nacl\_rules) | ./modules/nacl | n/a |
| <a name="module_main_vpc_public_route_table"></a> [main\_vpc\_public\_route\_table](#module\_main\_vpc\_public\_route\_table) | ./modules/route_table | n/a |
| <a name="module_main_vpc_public_subnet"></a> [main\_vpc\_public\_subnet](#module\_main\_vpc\_public\_subnet) | ./modules/subnets | n/a |
| <a name="module_main_vpc_sg"></a> [main\_vpc\_sg](#module\_main\_vpc\_sg) | ./modules/sg | n/a |
| <a name="module_vpc_dr"></a> [vpc\_dr](#module\_vpc\_dr) | ./modules/vpc | n/a |
| <a name="module_vpc_main"></a> [vpc\_main](#module\_vpc\_main) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection.main_vpc_peer_requestor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.dr_vpc_peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_ami.dr_vpc_latest_amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.main_vpc_latest_amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.dr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_availability_zones.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_dr_vpc_cidr"></a> [aws\_dr\_vpc\_cidr](#input\_aws\_dr\_vpc\_cidr) | CIDR block for the disaster recovery (DR) VPC (e.g., 10.1.0.0/16). | `string` | `"172.20.0.0/16"` | no |
| <a name="input_aws_dr_vpc_region"></a> [aws\_dr\_vpc\_region](#input\_aws\_dr\_vpc\_region) | The AWS region where the disaster recovery (DR) VPC will be deployed (e.g., us-west-2). | `string` | `"ca-central-1"` | no |
| <a name="input_aws_main_vpc_cidr"></a> [aws\_main\_vpc\_cidr](#input\_aws\_main\_vpc\_cidr) | CIDR block for the main VPC (e.g., 10.0.0.0/16). | `string` | `"192.168.0.0/16"` | no |
| <a name="input_aws_main_vpc_region"></a> [aws\_main\_vpc\_region](#input\_aws\_main\_vpc\_region) | The AWS region where the main VPC will be deployed (e.g., us-east-1). | `string` | `"us-east-1"` | no |
| <a name="input_my_public_ipv4"></a> [my\_public\_ipv4](#input\_my\_public\_ipv4) | The public IP address of your machine, used for allowing secure access (e.g., 203.0.113.10/32). | `string` | `"209.107.216.146/32"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dr_vpc_ec2_instance_private_ip"></a> [dr\_vpc\_ec2\_instance\_private\_ip](#output\_dr\_vpc\_ec2\_instance\_private\_ip) | n/a |
| <a name="output_dr_vpc_instance_type"></a> [dr\_vpc\_instance\_type](#output\_dr\_vpc\_instance\_type) | n/a |
| <a name="output_main_vpc_ec2_instance_public_ip"></a> [main\_vpc\_ec2\_instance\_public\_ip](#output\_main\_vpc\_ec2\_instance\_public\_ip) | n/a |
| <a name="output_main_vpc_ec2_isntance_private_ip"></a> [main\_vpc\_ec2\_isntance\_private\_ip](#output\_main\_vpc\_ec2\_isntance\_private\_ip) | n/a |
<!-- END_TF_DOCS -->