Table of Contents

- [Introduction](#introduction)
- [Architecture Diagram](#architecture-diagram)
- [Terraform Module Documentation](#terraform-module-documentation)
  - [Rquirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Key pair](#key-pair)
- [Connect to EC2 Instance](#connect-to-ec2-instance)
- [pre-commit](#pre-commit)
  - [pre-commit installation](#terraform-pre-commit-installation)
  - [pre-commit dependencies installation](#pre-commit-dependencies)
  - [pre-commit commands](#pre-commit-commands)
- [Execution](#execution)
  - [Execution Prerequisites](#exec-prerequisites)
  - [Setup Steps](#setup-steps)
  - [Additional Notes](#additional-notes)
- [References](#references)
- [Versions](#versions)

<br>

# Introduction

This Terraform lab demonstrates how to provision a VPC peering connection between two Virtual Private Clouds (VPCs) in Amazon Web Services (AWS). VPC peering enables private network connectivity between VPCs, allowing resources in one VPC to communicate with resources in another using private IP addresses — without requiring gateways, VPNs, or internet access.

# Architecture Diagram

![VPC Peering Architecture Diagram](./Architecture_diagram/VPC_Peering.jpg)

<br>
<br>

# Terraform Module Documentation

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
| <a name="input_my_public_ipv4"></a> [my\_public\_ipv4](#input\_my\_public\_ipv4) | The public IP address of your machine, used for allowing secure access (e.g., 203.0.113.10/32). | `string` | `"x.x.x.x/32"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dr_vpc_ec2_instance_private_ip"></a> [dr\_vpc\_ec2\_instance\_private\_ip](#output\_dr\_vpc\_ec2\_instance\_private\_ip) | The private IP address of the EC2 instance launched in the DR (Disaster Recovery) VPC |
| <a name="output_dr_vpc_instance_type"></a> [dr\_vpc\_instance\_type](#output\_dr\_vpc\_instance\_type) | The instance type of the EC2 instance deployed in the DR VPC |
| <a name="output_main_vpc_ec2_instance_public_ip"></a> [main\_vpc\_ec2\_instance\_public\_ip](#output\_main\_vpc\_ec2\_instance\_public\_ip) | The public IP address of the EC2 instance launched in the main VPC |
| <a name="output_main_vpc_ec2_isntance_private_ip"></a> [main\_vpc\_ec2\_isntance\_private\_ip](#output\_main\_vpc\_ec2\_isntance\_private\_ip) | The private IP address of the EC2 instance launched in the main VPC |
<!-- END_TF_DOCS -->

<br>

# Key pair

We generate a key pair to securely authenticate SSH access to an EC2 instance without using a password. The public key is stored on the instance, and the private key remains with the user to establish a trusted, encrypted connection.

```
ssh-keygen -t rsa -b 4096

# public key
~/.ssh/id_rsa.pub

# private key
~/.ssh/id_rsa
```

# Connect to EC2 instance

After successful Terraform execution, the output will display the public IP address of the EC2 instance deployed in the public subnet of the main VPC.

To connect to the instance via SSH, run the following command, replacing <your-ec2-public-ip> with the actual public IP from the Terraform output:

```
ssh -i ~/.ssh/id_rsa ec2-user@<your-ec2-public-ip>
```

# pre-commit

Pre-commit is a Git hook framework that runs automated checks on your code before each commit. It uses a configuration file to define which tools should scan your local repository. If any tool detects an issue—such as a misconfiguration or code that violates best practices—the commit will be blocked. This “shift-left” approach helps catch problems early, improving both code quality and security.

## Terraform pre-commit installation

| OS | Command |
|----|---------|
| Mac| brew install pre-commit |
| Windows | pip install pre-commit |

## pre-commit dependencies

| dependency | url |
|------------|-----|
| terrform-docs | https://github.com/terraform-docs/terraform-docs |

## pre-commit commands

| command | description |
|---------|-------------|
| pre-commit run terraform_docs --all-files | Run it the first time to Generate README.md |
| pre-commit clean | nukes the whole thing |
| pre-commit autoupdate | Update the rev for each repository defined in your .pre-commit-config.yaml to the latest available tag in the default branch |

# Execution

To successfully execute this Terraform project, please ensure you meet the following prerequisites and follow the setup steps below.

## Exec Prerequisites

Before you begin, make sure you have the following installed and configured on your local machine:

- [Create an AWS Account](https://aws.amazon.com/)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [Git](https://git-scm.com/downloads)
- Install [Visual Studio Code](https://code.visualstudio.com/)

## Setup Steps

Once the above prerequisites are in place, follow these steps to set up and run the project:

1. **[Fork the repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)** to your GitHub account.
2. **Create an IAM user** in AWS and generate an **Access Key ID** and **Secret Access Key**.

```
Assign the following AWS managed policies to the user:
  - AmazonEC2FullAccess
  - AmazonVPCFullAccess
```

3. **Configure AWS CLI** with the credentials:

```
bash
  aws configure 
```

4. Generate a key pair (with default names) in AWS EC2 or using the CLI. Make sure the private key is stored securely.
5. Update the my_public_ipv4 variable in the root module with your current public IP address.
6. Clone your forked repository and navigate to the project directory:

```
bash
  git clone https://github.com/<your-username>/<your-forked-repo>.git
  cd <your-forked-repo>
```

7. Initialize Terraform:

```
terraform init
```

8. Review the planned changes:

```
terraform plan
```

9. Apply the configuration:

```
terraform apply
```

## Additional Notes

Terraform format and validate will automatically run on each commit to enforce code quality and consistency.

## References

- [Create an AWS Account](https://aws.amazon.com/resources/create-account/)
- [Install Git](https://git-scm.com/downloads)
- [Install Visual Studio Code](https://code.visualstudio.com/download)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [AWS generate Access & Secret Key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terraform Workflow](https://developer.hashicorp.com/terraform/intro/core-workflow)
- [Terraform AWS VPC resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Terraform AWS Internet Gateway resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway.html)
- [Terraform AWS Subnet resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Terraform AWS Route Table resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [Terraform AWS Instance resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance.html)
- [Terraform AWS NACL resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl)
- [Terraform AWS Security Group resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Terraform AWS VPC Peering resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection)
- [Generate key pair](https://learn.microsoft.com/en-us/viva/glint/setup/sftp-ssh-key-gen)
- [Pre-commit](https://pre-commit.com)
- [Terraform pre-commit](https://github.com/antonbabenko/pre-commit-terraform)
- [Install pre-commit dependencies](https://github.com/antonbabenko/pre-commit-terraform?tab=readme-ov-file#1-install-dependencies)

<br>

## Versions

| Apps         | Version |
|--------------|---------|
| Terraform    | v1.3.9  |
| pre-commit   | 4.2.0   |
