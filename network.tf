#
# VPC AND SUBNETS
#

locals {
  cidr_block = "10.0.0.0/16"
}

# GITHUB ACTIONS KEEPS MAKING NEW VPC'S
/**
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
*/

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_config
  vpc_id     = local.cidr_block
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_config
  vpc_id     = local.cidr_block
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "public-${each.key}"
  }
}

