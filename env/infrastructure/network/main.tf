# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "env-default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.organization}-vpc-root_infrastructure_${var.env}-default"
  }
}

resource "aws_subnet" "env-workload" {
    for_each = var.map_of_workloads_cidr_blocks_and_account_ids

  vpc_id     = aws_vpc.env-default.id
  cidr_block = each.value.cidr

  tags = {
    Name = "${var.organization}-subnet-root_infrastructure_${var.env}-default_${each.key}"
  }
}
