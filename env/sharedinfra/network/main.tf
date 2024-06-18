# Configure the AWS Provider
provider "aws" {
  region = local.config.aws_region
}

resource "aws_vpc" "env-default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${local.organization}-vpc-${var.env}-default"
  }
}

locals {
  config = yamldecode(file(var.path_config_yaml))
  
  organization = local.config.organization

  account_network_details = flatten([
    for ou_name, ou_value in local.config["aws-organizational-units"] : [
      for account in ou_value["aws-accounts"] : {
        account_name = account.name
        cidr         = account.subnet.cidr
        ou_name      = ou_name
        sg           = account.subnet["security-groups"]
        subnet       = account.subnet
      } if lookup(account, "subnet", null) != null
    ]
  ])

  security_groups = flatten([
    for details in local.account_network_details :
    [
      for sg in details.sg :
      {
        account_name  = details.account_name
        allow_ingress = sg.allow-ingress
        cidr          = details.cidr
        name          = sg.name
        subnet        = details.subnet
      }
    ]
  ])
}

resource "aws_subnet" "env-public" {
  for_each = local.account_network_details

  vpc_id     = aws_vpc.env-default.id
  cidr_block = each.value.cidr

  tags = {
    Name = "${local.organization}-subnet_public-${each.value.ou_name}_${var.env}-${each.value.account_name}"
  }
}

resource "aws_security_group" "env" {
  for_each = local.security_groups

  vpc_id = aws_vpc.env-default.id

  dynamic "ingress" {
    for_each = each.value.allow_ingress ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${each.value.account_name}_${var.env}_${each.value.sg_name}"
  }
}