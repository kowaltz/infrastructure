# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "env-default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.organization}-vpc-${var.env}-default"
  }
}

locals {
  config = yamldecode(file(var.path_config_yaml))

  account_network_details = {
    for account in local.config.aws-organizational-units.workloads.aws-accounts :
    account.name => {
      subnet = account.subnet
      cidr   = account.subnet.cidr
      sg     = account.subnet.security-groups
    }
    if account.subnet.enabled
  }

  security_groups = flatten([
    for account, details in local.account_network_details :
    [
      for sg in details.sg :
      {
        allow_ingress = sg.allow-ingress
        account_name  = account
        cidr          = details.cidr
        name          = sg.name
        subnet        = details.subnet
      }
    ]
  ])
}

resource "aws_subnet" "workload-env-public" {
  for_each = local.account_network_details

  vpc_id     = aws_vpc.env-default.id
  cidr_block = each.value.cidr

  tags = {
    Name = "${var.organization}-subnet_public-workloads_${var.env}-${each.key}"
  }
}

resource "aws_security_group" "workload-env-security_group" {
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
    Name = "${each.value.account_name}_${var.env}_${each.value.name}"
  }
}